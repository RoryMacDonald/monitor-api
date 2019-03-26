require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/baseline/amend' do
  guard_access env, params, request do |request_hash|

    amend_response = @dependency_factory.get_use_case(:amend_baseline).execute(
      project_id: request_hash[:project_id].to_i
    )
    
    response.body = {
      baselineId: amend_response[:id],
      timestamp: amend_response[:timestamp],
      errors: amend_response[:errors]
    }.to_json

    response.status = 200
  end
end
