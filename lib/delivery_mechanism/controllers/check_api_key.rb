require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/apikey/check' do
  return 400 if env['HTTP_API_KEY'].nil?

  request_hash = get_hash(request)

  api_key_info = @dependency_factory.get_use_case(:check_api_key).execute(
    api_key: env['HTTP_API_KEY'],
    project_id: request_hash[:project_id]
  )

  if api_key_info[:valid]
    response.body = {email: api_key_info[:email], role: api_key_info[:role]}.to_json
    response.status = 201
  else
    response.status = 401
  end
end
