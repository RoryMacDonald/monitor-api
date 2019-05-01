require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/review/create' do
  guard_access env, params, request do |request_hash|
    new_review = @dependency_factory.get_use_case(:ui_create_review).execute(
      project_id: request_hash[:project_id],
      review_data: request_hash[:data]
    )

    response.body = {id: new_review[:id]}.to_json
    response.status = 201
  end
end
