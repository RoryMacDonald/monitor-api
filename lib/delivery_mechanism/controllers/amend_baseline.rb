require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/baseline/amend' do
  guard_access env, params, request do |request_hash|

    amend_response = @dependency_factory.get_use_case(:ui_amend_baseline).execute(
      project_id: request_hash[:project_id].to_i,
      data: request_hash[:data],
      timestamp: request_hash[:timestamp].to_i
    )
    
    response.body = {
      baselineId: amend_response[:id],
      errors: amend_response[:errors],
      timestamp: amend_response[:timestamp] 
    }.to_json

    response.status = 200
  end
end
