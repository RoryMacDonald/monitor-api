require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/return' do
  guard_access env, params, request do 
    return 400 if params['id'].nil?

    base_return = @dependency_factory.get_use_case(:ui_get_base_return).execute(
      project_id: params['id'].to_i
    )

    if base_return.empty?
      response.status = 404
    else
      response.headers['Cache-Control'] = 'no-cache'
      response.status = 200
      response.body = { baseReturn: base_return[:base_return] }.to_json
    end
  end
end