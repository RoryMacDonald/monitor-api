require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/monthly-catch-up/submit' do
  guard_access env, params, request do |request_hash|
    @dependency_factory.get_use_case(:submit_monthly_catchup).execute(monthly_catchup_id: request_hash[:monthly_catchup_id])
  end
end
