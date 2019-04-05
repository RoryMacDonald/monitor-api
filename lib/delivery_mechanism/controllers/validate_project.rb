require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/project/validate' do
  guard_access env, params, request do |request_hash|
    return 400 if invalid_validation_hash(request_hash: request_hash)

    data = @dependency_factory.get_use_case(:sanitise_data).execute(data: request_hash[:data])

    validate_response = @dependency_factory.get_use_case(:ui_validate_project).execute(
      type: request_hash[:type],
      project_data: data
    )

    response.status = 200
    response.body = {
      valid: validate_response[:valid],
      invalidPaths: validate_response[:invalid_paths],
      prettyInvalidPaths: validate_response[:pretty_invalid_paths]
    }.to_json
  end
end