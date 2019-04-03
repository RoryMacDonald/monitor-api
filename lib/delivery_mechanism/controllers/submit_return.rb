require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/return/submit' do
  guard_access env, params, request do |request_hash, user_info|

    @dependency_factory.get_use_case(:submit_return).execute(
      return_id: request_hash[:return_id].to_i
    )

    @dependency_factory.get_use_case(:notify_project_members_of_submission).execute(
      project_id: request_hash[:project_id].to_i,
      url: request_hash[:url],
      by: user_info[:email]
    )

    response.status = 200
  end
end
