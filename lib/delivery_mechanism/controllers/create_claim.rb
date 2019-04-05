require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/claim/create' do
  guard_access env, params, request do |request_hash|

    data = @dependency_factory.get_use_case(:sanitise_data).execute(data: request_hash[:data])

    claim_id = @dependency_factory.get_use_case(:ui_create_claim).execute(
      project_id: request_hash[:project_id],
      claim_data: data
    )

    response.tap do |r|
      r.body = { id: claim_id[:claim_id] }.to_json
      r.status = 201
    end
  end
end
