require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/claim/update' do
  guard_access env, params, request do |request_hash|
    if request_hash[:claim_data].nil? || request_hash[:claim_id].nil?
      return 400
    end

    data = @dependency_factory.get_use_case(:sanitise_data).execute(data: request_hash[:claim_data])

    @dependency_factory.get_use_case(:ui_update_claim).execute(
      claim_id: request_hash[:claim_id], claim_data: data
    )

    200
  end
end
