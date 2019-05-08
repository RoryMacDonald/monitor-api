require_relative '../web_routes.rb'

unless ENV['BACK_TO_BASELINE'].nil?
  DeliveryMechanism::WebRoutes.post '/project/unsubmit' do
    guard_access env, params, request do |request_hash|
      @dependency_factory.get_use_case(:unsubmit_project).execute(
        project_id: request_hash[:project_id].to_i
      )

      response.status = 200
    end
  end
end