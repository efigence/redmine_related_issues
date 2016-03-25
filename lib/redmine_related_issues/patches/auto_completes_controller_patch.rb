require_dependency 'auto_completes_controller'

module RedmineRelatedIssues
  module Patches
    module AutoCompletesControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          alias_method_chain :issues, :added
        end
      end

      module InstanceMethods
        def issues_with_added
          @issues = []
          q = (params[:q] || params[:term]).to_s.strip
          if q.present?
            scope = Issue.cross_project_scope(@project, params[:scope]).visible.where.not(id: params[:previousterm].split(',').map(&:strip))
            if q.match(/\A#?(\d+)\z/)
              @issues << scope.find_by_id($1.to_i)
            end
            @issues += scope.where("LOWER(#{Issue.table_name}.subject) LIKE LOWER(?)", "%#{q}%").order("#{Issue.table_name}.id DESC").limit(10).to_a
            @issues.compact!
          end
          render :layout => false
        end
      end
    end
  end
end
