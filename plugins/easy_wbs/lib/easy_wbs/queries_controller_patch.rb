module EasyWbs
  module QueriesControllerPatch

    def self.prepended(base)
      base.prepend(InstanceMethods)
    end

    module InstanceMethods

      # Redmine return only direct sublasses but
      # Wbs query inherit from IssueQuery
      def query_class
        case params[:type]
        when 'EasyWbs::IssueQuery'
          EasyWbs::IssueQuery
        else
          super
        end
      end

    end

  end
end

QueriesController.prepend EasyWbs::QueriesControllerPatch
