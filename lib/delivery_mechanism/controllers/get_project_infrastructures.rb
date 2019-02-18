require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/infrastructures' do
  guard_access env, params, request do |_|
    infrastructures = @dependency_factory.get_use_case(
      :get_infrastructures
    ).execute(project_id: params['id'].to_i)
    infrastructures.to_json
  end
end
