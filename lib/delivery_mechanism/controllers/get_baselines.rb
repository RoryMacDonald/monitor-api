require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/baselines' do
  guard_access env, params, request do |_|
    return 404 if params['id'].nil?
    baselines = @dependency_factory.get_use_case(:ui_get_baselines).execute(
      project_id: params['id'].to_i
    )

    content_type 'application/json'
    
    response.headers['Cache-Control'] = 'no-cache'
    response.status = baselines.empty? ? 404 : 200
    response.body = baselines.to_json
  end
end
