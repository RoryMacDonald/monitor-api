require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/baseline/amend' do
  guard_access env, params, request do |request_hash|

    amend_response = @dependency_factory.get_use_case(:amend_baseline).execute(
      project_id: request_hash[:project_id].to_i,
      data: request_hash[:data],
      timestamp: request_hash[:timestamp].to_i
    )
    
    if amend_response[:success] 
      response.body = { baselineId: amend_response[:id] }.to_json
    else
      response.body = { errors: amend_response[:errors] }.to_json
    end
    response.status = 200
  end
end
