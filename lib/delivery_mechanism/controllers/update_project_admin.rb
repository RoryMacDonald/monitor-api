require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/project/admin/update' do
  guard_access env, params, request do |request_hash|
    if valid_update_request_body(request_hash)
      use_case = @dependency_factory.get_use_case(:update_project_admin)

      update_response = use_case.execute(
        project_id: request_hash[:project_id].to_i,
        data: request_hash[:project_data],
        timestamp: request_hash[:timestamp].to_i
      )

      response.status = update_successful?(update_response) ? 200 : 404
      response.body = { errors: update_response[:errors], timestamp: update_response[:timestamp] }.to_json
    else
      response.status = 400
    end
  end
end
