require_relative '../shared_context/dependency_factory'
require_relative '../../simulator/notification'

describe 'Notifying project members of project creation' do
  include_context 'dependency factory'

  let(:environment_before) { ENV }
  let(:notification_url) { 'http://meow.cat/' }
  let(:notification_request) do
    stub_request(:post, "#{notification_url}v2/notifications/email").to_return(status: 200, body: {}.to_json)
  end
  let(:simulator) { Simulator::Notification.new(self, notification_url) }

  let(:new_project) do
    HomesEngland::Domain::Project.new.tap do |p|
      p.name = "Cat cafe"
      p.data = {}
    end
  end

  let(:project_id) do
    dependency_factory.get_gateway(:project).create(new_project)
  end

  def given_a_project_with_a_user
    dependency_factory.get_use_case(:add_user_to_project).execute(project_id: project_id, email: 'cat@meow.com')
  end

  def when_we_notify_users_that_the_project_is_created
    dependency_factory.get_use_case(:notify_project_members_of_creation).execute(project_id: project_id, url: 'meow.com')
  end

  def then_we_send_a_notification_to_the_users
    simulator.expect_notification_to_have_been_sent_with(access_url: 'meow.com')
  end

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

  it 'notifies project members' do
    given_a_project_with_a_user
    when_we_notify_users_that_the_project_is_created
    then_we_send_a_notification_to_the_users
  end
end
