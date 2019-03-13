require_relative '../shared_context/dependency_factory'
require_relative '../../simulator/notification'

describe 'Notifying project members' do
  include_context 'dependency factory'
  let(:notification_url) { 'http://meow.cat/' }
  let(:simulator) { Simulator::Notification.new(self, notification_url) }
  let(:notification_request) do
    stub_request(:post, "#{notification_url}v2/notifications/email").to_return(status: 200, body: {}.to_json)
  end
  
  before do
    ENV['GOV_NOTIFY_API_KEY'] = 'cafe-cafecafe-cafe-cafe-cafe-cafecafecafe-cafecafe-cafe-cafe-cafe-cafecafecafe'
    ENV['GOV_NOTIFY_API_URL'] = notification_url

    @project_id = dependency_factory.get_use_case(:create_new_project).execute(name: "Cat cafe", type: 'hif', baseline: {}, bid_id: 'HIF/MV')[:id]
    dependency_factory.get_use_case(:add_user_to_project).execute(project_id: @project_id, email: 'cat@meow.com')
    simulator.send_notification(to: 'cat@meow.com')
  end

  it 'Notfies project members' do
    dependency_factory.get_use_case(:notify_project_members_of_submission).execute(project_id: @project_id, url: 'meow.com', by: 'cat')
    simulator.expect_notification_to_have_been_sent_with(access_url: 'meow.com')
  end
end
