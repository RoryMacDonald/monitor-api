require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/claims' do
  guard_access env, params, request do |_|
    return 404 if params['id'].nil?
    claims = @dependency_factory.get_use_case(:ui_get_claims).execute(
      project_id: params['id'].to_i
    )

    content_type 'application/json'
    
    response.headers['Cache-Control'] = 'no-cache'
    response.status = claims.empty? ? 404 : 200
    response.body = claims.to_json
  end
end
