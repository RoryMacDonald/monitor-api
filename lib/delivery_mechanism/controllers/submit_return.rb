require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/return/submit' do
  guard_access env, params, request do |request_hash|

    actor_email = @dependency_factory.get_use_case(:check_api_key).execute(
      api_key: env['HTTP_API_KEY'],
      project_id: request_hash[:project_id]
    )[:email]

    @dependency_factory.get_use_case(:submit_return).execute(
      return_id: request_hash[:return_id].to_i
    )

    @dependency_factory.get_use_case(:notify_project_members_of_submission).execute(
      project_id: request_hash[:project_id].to_i,
      url: request_hash[:url],
      by: actor_email
    )

    response.status = 200
  end
end
