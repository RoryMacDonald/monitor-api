require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/find' do
  guard_access env, params, request do |_|
    return 404 if params['id'].nil?
    project = @dependency_factory.get_use_case(:ui_get_project).execute(
      id: params['id'].to_i
    )

    return 404 if project.nil?

    content_type 'application/json'
    response.body = {
      type: project[:type],
      status: project[:status],
      bid_id: project[:bid_id],
      data: Common::DeepCamelizeKeys.to_camelized_hash(project[:data]),
      schema: project[:schema],
      timestamp: project[:timestamp]
    }.to_json
    response.headers['Cache-Control'] = 'no-cache'
    response.status = 200
  end
end
