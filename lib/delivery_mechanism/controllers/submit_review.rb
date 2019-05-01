require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/review/submit' do
  guard_access env, params, request do |request_hash|
    @dependency_factory.get_use_case(:submit_review).execute(review_id: request_hash[:review_id])
  end
end
