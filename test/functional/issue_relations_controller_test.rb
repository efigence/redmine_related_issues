require File.expand_path('../../test_helper', __FILE__)

class IssueRealtionsControllerTest < Redmine::IntegrationTest
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')
  fixtures :users,
           :issues,
           :projects,
           :issue_statuses,
           :members,
           :settings,
           :roles,
           :enabled_modules,
           :time_entries,
           :trackers,
           :email_addresses,
           :groups_users,
           :member_roles,
           :enumerations

  def setup

  end

  def test_start_issue_should_create_new_hamster_issue
    log_user('jsmith', 'jsmith')
    post issue_relations_path(Issue.find(1)), relation: { relation_type: 'relates', issue_to_id: 'xxx, 2, sdf, 3, 213123, ', delay: '' }
    output = assigns(:saved_relations).map { |rel| [rel.id, rel.issue_from_id, rel.issue_to_id] }
    output.each { |relation| assert relation[1] == 1 }
    assert output[0][2].nil?
    assert output[1][2] == 2
    assert output[2][2].nil?
    assert output[3][2] == 3
    assert output[4][2].nil?
  end

end
