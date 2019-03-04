require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/claim/get' do
  guard_access env, params, request do |_|
    return 400 if params[:claimId].nil?
    claim_id = params[:claimId].to_i

    claim_hash = @dependency_factory.get_use_case(:ui_get_claim).execute(
      claim_id: claim_id
    )

    return 404 if claim_hash.empty?

    response.body = {
      project_id: claim_hash[:project_id],
      data: claim_hash[:data],
      status: claim_hash[:status],
      schema: claim_hash[:schema],
      type: claim_hash[:type]
    }.to_json
    response.headers['Cache-Control'] = 'no-cache'
    response.status = 200
  end
end
