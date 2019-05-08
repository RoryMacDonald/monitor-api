require_relative '../shared_context/dependency_factory'
require_relative '../../simulator/notification'

 describe 'Notifying project members' do
  include_context 'dependency factory'
  let(:notification_url) { 'http://meow.cat/' }
  let(:simulator) { Simulator::Notification.new(self, notification_url) }

  let(:project_id) do
    dependency_factory
      .get_use_case(:create_new_project)
      .execute(name: "Cat cafe", type: 'hif', baseline: {}, bid_id: 'HIF/MV')[:id]
  end


  let(:environment_before) { ENV }

  before do
    environment_before
    ENV['GOV_NOTIFY_API_KEY'] = 'cafe-cafecafe-cafe-cafe-cafe-cafecafecafe-cafecafe-cafe-cafe-cafe-cafecafecafe'
    ENV['GOV_NOTIFY_API_URL'] = notification_url

    simulator.stub_send_notification(to: 'cat@meow.com')
  end

  after do
    ENV['GOV_NOTIFY_API_KEY'] = environment_before['GOV_NOTIFY_API_KEY']
    ENV['GOV_NOTIFY_API_URL'] = environment_before['GOV_NOTIFY_API_URL']
  end

  def given_a_user
    dependency_factory
      .get_use_case(:add_user_to_project)
      .execute(project_id: project_id, email: 'cat@meow.com')
  end

  def when_a_notification_is_sent
    dependency_factory
      .get_use_case(:notify_project_members_of_submission)
      .execute(project_id: project_id, url: 'meow.com', by: 'cat')
  end

  def then_a_request_to_the_notify_api_is_made
    simulator.expect_notification_to_have_been_sent_with(access_url: 'meow.com')
  end

  it 'Notifes project members' do
    given_a_user
    when_a_notification_is_sent
    then_a_request_to_the_notify_api_is_made
  end
end
