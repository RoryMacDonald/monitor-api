require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/export' do
  response.body = {}.to_json
  guard_bi_access env, params, request do |_request_hash|
    exported_project_hash = @dependency_factory.get_use_case(:export_project_data).execute(
      project_id: params['id'].to_i
    )

    if exported_project_hash.empty?
      response.status = 404
      response.body = {}.to_json
    else
      exported_project_hash[:compiled_project].to_json
    end
  end
end