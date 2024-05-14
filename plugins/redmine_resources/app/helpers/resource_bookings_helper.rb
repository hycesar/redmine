# encoding: utf-8
#
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

module ResourceBookingsHelper
  include RedmineResources::Charts::Helpers::ChartHelper

  def warning_messages_for(*objects)
    objects = objects.map { |o| o.is_a?(String) ? instance_variable_get("@#{o}") : o }.compact
    warnings = objects.map { |o| o.warnings.full_messages }.flatten
    render_warning_messages(warnings)
  end

  def render_warning_messages(warnings)
    html = ''
    if warnings.present?
      html << "<div id='warningExplanation' class='warning'><ul>\n"
      warnings.each do |warning|
        html << "<li>#{h warning}</li>\n"
      end
      html << "</ul></div>\n"
    end
    html.html_safe
  end

  def chart_type_options
    options = ResourceBookingQuery::CHART_TYPES.map { |x| [l("label_resources_#{x}"), x] }

    options << [l(:label_resources_allocation_table_pro), :pro]
    options << [l(:label_resources_issues_chart_pro), :pro]
    options
  end

  def workload_type_options
    ResourceBookingQuery::WORKLOAD_TYPES.map { |x| [l("label_resources_workload_in_#{x}"), x] }
  end

  def line_title_type_options
    options = RedmineResources::Charts::MonthViewBookingsChart::LINE_TITLE_TYPES.map { |x| [l("label_resources_#{x}"), x] }
    options << [l(:label_resources_issue_subject_pro), :pro]
    options << [l(:label_resources_hours_per_day_pro), :pro]
    options
  end

  def custom_options_for_select(options, selected_option)
    options_for_select(options,
                       disabled: :pro,
                       selected: selected_option)
  end

  def check_box_with_label(value, label, disabled = false)
    value = :pro
    label = "#{label}_pro"
    disabled = true
    check_box('query', value, id: value, disabled: disabled) + l(label)
  end

  def gray_hint(id, issue_attr=nil)
    if ['user_workload', 'days_count', 'dayoffs_count'].include?(id)
      translation = l("label_resources_#{id}")
      content_tag(:span, issue_attr, id: id, class: 'modal-hint', data: { translation: translation })
    else
      content_tag(:span, issue_attr, id: id, class: 'modal-hint')
    end
  end

  def bookings_index_path
    @project ? project_resource_bookings_path(project_id: @project) : resource_bookings_path
  end
end
