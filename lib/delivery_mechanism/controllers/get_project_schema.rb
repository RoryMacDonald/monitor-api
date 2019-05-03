require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/baseline/:type' do
  schema = @dependency_factory.get_use_case(:get_schema_for_project).execute(type: params['type'])
  return 404 if schema.nil?
  response.body = schema.to_json
  response.headers['Cache-Control'] = 'no-cache'
  response.status = 200
end