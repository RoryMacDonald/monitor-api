require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/user/projects' do
  guard_access env, params, request do |_, user_info|
    project_list = @dependency_factory
      .get_use_case(:get_user_projects)
      .execute(email: user_info[:email])[:project_list]

    content_type 'application/json'
    response.body = {
      project_list: project_list
    }.to_json
    response.headers['Cache-Control'] = 'no-cache'
    response.status = 200
  end
end
