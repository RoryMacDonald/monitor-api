require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/monthly-catch-up/create' do
  guard_access env, params, request do |request_hash|
    new_monthly_catchup = @dependency_factory.get_use_case(:ui_create_monthly_catchup).execute(
      project_id: request_hash[:project_id],
      monthly_catchup_data: request_hash[:data]
    )

    response.body = {id: new_monthly_catchup[:id]}.to_json
    response.status = 201
  end
end
