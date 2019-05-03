require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/projects/export' do
  response.body = {}.to_json
  guard_bi_access env, params, request do |_request_hash|
    {
      projects:
        @dependency_factory.get_use_case(:export_all_projects).execute[:compiled_projects]
    }.to_json
  end
end