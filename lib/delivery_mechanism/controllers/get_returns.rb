require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/returns' do
  guard_access env, params, request do |_|
    returns = @dependency_factory.get_use_case(:ui_get_returns).execute(project_id: params['id'].to_i)
    response.headers['Cache-Control'] = 'no-cache'
    response.status = returns.empty? ? 404 : 200
    response.body = returns.to_json
  end
end