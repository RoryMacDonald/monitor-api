require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/claim/validate' do
  guard_access env, params, request do |request_hash|
    return 400 if invalid_validation_hash(request_hash: request_hash)

    validate_response = @dependency_factory.get_use_case(:ui_validate_claim).execute(
      type: request_hash[:type],
      claim_data: request_hash[:data]
    )

    response.status = 200
    response.body = {
      valid: validate_response[:valid],
      invalidPaths: validate_response[:invalid_paths],
      prettyInvalidPaths: validate_response[:pretty_invalid_paths]
    }.to_json
  end
end
