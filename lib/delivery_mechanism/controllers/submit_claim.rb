require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/claim/submit' do
  guard_access env, params, request do |request_hash, user_info|

    @dependency_factory.get_use_case(:submit_claim).execute(
      claim_id: request_hash[:claim_id].to_i
    )

    @dependency_factory.get_use_case(:notify_project_members_of_submission).execute(
      project_id: request_hash[:project_id].to_i,
      url: request_hash[:url],
      by: user_info[:email],
      type: :claim
    )

    response.status = 200
  end
end
