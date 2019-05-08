require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/project/submit' do
  guard_access env, params, request do |request_hash|
    @dependency_factory.get_use_case(:submit_project).execute(
      project_id: request_hash[:project_id].to_i
    )

    @dependency_factory.get_use_case(:notify_project_members_of_creation).execute(project_id: request_hash[:project_id].to_i, url: request_hash[:url])

    response.status = 200
  end
end