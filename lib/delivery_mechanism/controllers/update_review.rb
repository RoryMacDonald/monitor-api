require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/review/update' do
  guard_access env, params, request do |request_hash|
    @dependency_factory.get_use_case(:ui_update_review).execute(
      project_id: request_hash[:project_id],
      review_id: request_hash[:review_id],
      review_data: request_hash[:review_data]
    )
  end
end
