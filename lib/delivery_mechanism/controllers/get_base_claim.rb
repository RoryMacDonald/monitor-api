require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/claim' do
  guard_access env, params, request do |_|
    return 400 if params['id'].nil?

    base_claim = @dependency_factory.get_use_case(:ui_get_base_claim).execute(
      project_id: params['id'].to_i
    )

    return 404 if base_claim.empty?

    response.body = {
      baseClaim: base_claim[:base_claim]
    }.to_json
    response.headers['Cache-Control'] = 'no-cache'
    response.status = 200
  end
end