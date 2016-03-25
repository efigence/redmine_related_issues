require_dependency 'issue_relations_controller'

module RedmineRelatedIssues
  module Patches
    module IssueRelationsControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          alias_method_chain :create, :multiple
        end
      end

      module InstanceMethods
        def create_with_multiple
          @issue = Issue.find(params[:issue_id])
          @saved_relations = []
          params[:relation][:issue_to_id].split(', ').each.with_index do |related_issue_id, index|
            @saved_relations[index] = IssueRelation.new(params[:relation])
            @saved_relations[index].issue_from = @issue
            if params[:relation] && m = related_issue_id.to_s.strip.match(/^#?(\d+)$/)
              @saved_relations[index].issue_to = Issue.visible.find_by_id(m[1].to_i)
            end
            @saved_relations[index].init_journals(User.current)
            @saved_relations[index].save
            @relation ||= @saved_relations[index]
          end

          respond_to do |format|
            format.html { redirect_to issue_path(@issue) }
            format.js do
              @relations = @issue.reload.relations.select { |r| r.other_issue(@issue) && r.other_issue(@issue).visible? }
            end
            format.api do
              if saved
                render action: 'show', status: :created, location: relation_url(@relation)
              else
                render_validation_errors(@saved_relations)
              end
            end
          end
        end
      end
    end
  end
end
