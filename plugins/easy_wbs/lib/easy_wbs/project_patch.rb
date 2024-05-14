module EasyWbs
  module ProjectPatch

    def self.prepended(base)
      base.include InstanceMethods

      base.class_eval do
        before_destroy :remove_wbs_layout
      end
    end

    module InstanceMethods

      def assignable_users_including_all_subprojects
        if Setting.display_subprojects_issues?
          types = ['User']
          types << 'Group' if Setting.issue_group_assignment?

          @assignable_users_including_all_subprojects ||= Principal.
            active.
            joins(:members => :roles).
            where(:type => types, :roles => {:assignable => true}).
            where(:members => {:project_id => Project.where("lft >= ? AND rgt <= ?", lft, rgt)}).distinct.sorted
        else
          assignable_users
        end
      end

      def remove_wbs_layout
        Setting.plugin_easy_mindmup["easy_wbs_layout_#{id}"] = nil
      end

    end

  end
end

Project.prepend EasyWbs::ProjectPatch
