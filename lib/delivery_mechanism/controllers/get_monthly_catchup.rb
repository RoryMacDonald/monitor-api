require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/monthly-catch-up/get' do
  guard_access env, params, request do |request_hash|
    project_id = params['id'].to_i
    monthly_catchup_id = params['monthly_catchup_id'].to_i
    @dependency_factory.get_use_case(:ui_get_monthly_catchup).execute(project_id: project_id, monthly_catchup_id: monthly_catchup_id).then do |monthly_catchup|
      {
        id: monthly_catchup[:id],
        project_id: monthly_catchup[:project_id],
        data: monthly_catchup[:data],
        status: monthly_catchup[:status]
      }.to_json
    end
  end
end
