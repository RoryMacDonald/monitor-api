require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/claim/submit' do
  guard_access env, params, request do |request_hash|

    @dependency_factory.get_use_case(:submit_claim).execute(
      claim_id: request_hash[:claim_id].to_i
    )

    response.status = 200
  end
end
