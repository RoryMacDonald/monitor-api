require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/monthly-catch-up/update' do
  guard_access env, params, request do |request_hash|
    @dependency_factory.get_use_case(:ui_update_monthly_catchup).execute(
      project_id: request_hash[:project_id],
      monthly_catchup_id: request_hash[:monthly_catchup_id],
      monthly_catchup_data: request_hash[:monthly_catchup_data]
    )
  end
end
