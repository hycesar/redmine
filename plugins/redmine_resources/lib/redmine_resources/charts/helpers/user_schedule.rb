# This file is a part of Redmine Resources (redmine_resources) plugin,
# resource allocation and management for Redmine
#
# Copyright (C) 2011-2024 RedmineUP
# http://www.redmineup.com/
#
# redmine_resources is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_resources is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_resources.  If not, see <http://www.gnu.org/licenses/>.

module RedmineResources
  module Charts
    module Helpers
      class UserSchedule
        include Redmine::Utils::DateCalculation

        attr_reader :user, :resource_bookings, :plans, :capacity_hours, :allocated_hours, :spent_hours, :workload_percent, :plans_group_by_project

        def initialize(user, date_from, date_to, resource_bookings, time_entries)
          raise ArgumentError unless user

          @user = user
          @user_workday_length = workday_length_by(user)
          @date_from = date_from
          @date_to = date_to
          @resource_bookings = resource_bookings
          @time_entries = time_entries
          @plans = build_plans(@resource_bookings, @time_entries)

          @plans_group_by_project = {}
          @resource_bookings.group_by(&:project).each do |project, resource_bookings|
            plans = build_plans(resource_bookings, @time_entries)
            @plans_group_by_project[project] = plans
          end

          @capacity_hours = @user_workday_length * working_days(@date_from, @date_to)
          @allocated_hours = @resource_bookings.sum(&:hours_per_day)
          @spent_hours = @time_entries.sum(&:hours)
          @workload_percent = (@allocated_hours / @capacity_hours * 100).to_i
        end

        private

        def build_plans(resource_bookings, time_entries)
            (@date_from..@date_to).map do |day|
              resource_bookings_by_day = resource_bookings.select { |rb| rb.interval.cover?(day) }
              time_entries_by_day = time_entries.select { |time_entry| time_entry.spent_on == day }
              Plan.new(day, non_working_week_days.exclude?(day.cwday), resource_bookings_by_day, time_entries_by_day, @user_workday_length)
            end
        end

        def prepare_workday_info(day, dayoffs_by_day)
          if dayoffs_by_day.present?
            if dayoffs_by_day.any? { |dayoff| dayoff.hours_per_day.nil? }
              ['dayoff', @user_workday_length]
            else
              workday_length_correction = dayoffs_by_day.map(&:hours_per_day).sum
              workday_length = @user_workday_length - workday_length_correction
              if workday_length > 0
                ['part_dayoff', workday_length]
              else
                ['dayoff', @user_workday_length]
              end
            end
          else
            [non_working_week_days.exclude?(day.cwday), @user_workday_length]
          end
        end

        def dayoff_interval(dayoff)
          (dayoff.start_date..dayoff.due_date)
        end

        def people_pro_plugin_installed?
          RedmineResources.people_pro_plugin_installed?
        end

        def dayoffs
          condition_sql = <<-SQL.squish
            (
            (dayoffs.end_date is null AND dayoffs.start_date BETWEEN :date_from AND :date_to) OR
            (dayoffs.start_date <= :date_to AND dayoffs.end_date >= :date_from)
            ) AND
            (leave_types.approvable = false OR dayoffs.approved = true)
          SQL

          @user.dayoffs
          .joins(:leave_type)
          .where(condition_sql, date_to: @date_to, date_from: @date_from)
        end

        def workday_length_by(user)
          person = user.becomes(Person) if people_pro_plugin_installed?
          person.try(:workday_length) || RedmineResources.default_workday_length
        end
      end
    end
  end
end
