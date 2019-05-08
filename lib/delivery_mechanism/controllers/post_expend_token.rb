require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/token/expend' do
  request_hash = get_hash(request)
  expend_response = @dependency_factory.get_use_case(:expend_access_token).execute(
    access_token: request_hash[:access_token]
  )
  status = expend_response[:status]
  if status == :success
    response.status = 202
    response.body = { apiKey: expend_response[:api_key], role: expend_response[:role] }.to_json
  else
    response.status = 401
  end
end