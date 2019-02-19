require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/infrastructures' do
  guard_access env, params, request do
    infrastructures = @dependency_factory.get_use_case(
      :get_infrastructures
    ).execute(project_id: params['id'].to_i)

    content_type 'application/json'
    response.headers['Cache-Control'] = 'no-cache'
    response.status = 200
    response.body = infrastructures.to_json
  end
end
