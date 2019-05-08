require_relative '../shared_context/dependency_factory'
require_relative '../../simulator/notification'

describe 'Notifying project members' do
  include_context 'dependency factory'

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

  before do
    ENV['GOV_NOTIFY_API_KEY'] = 'cafe-cafecafe-cafe-cafe-cafe-cafecafecafe-cafecafe-cafe-cafe-cafe-cafecafecafe'
    ENV['GOV_NOTIFY_API_URL'] = notification_url

    @project_id = dependency_factory.get_gateway(:project).create(new_project)
    dependency_factory.get_use_case(:add_user_to_project).execute(project_id: @project_id, email: 'cat@meow.com')
    simulator.stub_send_notification(to: 'cat@meow.com')
  end

  it 'notifies project members' do
    dependency_factory.get_use_case(:notify_project_members_of_creation).execute(project_id: @project_id, url: 'meow.com')
    simulator.expect_notification_to_have_been_sent_with(access_url: 'meow.com')
  end
end
