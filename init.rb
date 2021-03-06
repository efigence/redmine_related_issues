Redmine::Plugin.register :redmine_related_issues do
  name 'Redmine Related Issues plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/efigence/redmine_related_issues'
  author_url 'https://github.com/efigence'

  ActionDispatch::Callbacks.to_prepare do
    IssueRelationsController.send(:include, RedmineRelatedIssues::Patches::IssueRelationsControllerPatch)
    AutoCompletesController.send(:include, RedmineRelatedIssues::Patches::AutoCompletesControllerPatch)
  end
end
