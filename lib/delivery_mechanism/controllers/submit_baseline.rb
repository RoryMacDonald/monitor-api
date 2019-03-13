require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/baseline/submit' do
  guard_access env, params, request do |request_hash|
    @dependency_factory.get_use_case(:submit_baseline).execute(
      id: request_hash[:baseline_id].to_i
    )

    response.status = 200
  end
end
