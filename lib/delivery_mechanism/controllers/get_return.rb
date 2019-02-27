require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/return/get' do
  guard_access env, params, request do |_|
    return 400 if params[:returnId].nil?
    return_id = params[:returnId].to_i

    return_hash = @dependency_factory.get_use_case(:ui_get_return).execute(
      id: return_id
    )

    return 404 if return_hash.empty?

    return_schema = @dependency_factory
                    .get_use_case(:ui_get_schema_for_return)
                    .execute(type: return_hash[:type])[:schema]

    response.body = {
      project_id: return_hash[:project_id],
      data: return_hash[:updates].last,
      status: return_hash[:status],
      schema: return_schema,
      type: return_hash[:type],
      no_of_previous_returns: return_hash[:no_of_previous_returns]
    }.to_json
    response.headers['Cache-Control'] = 'no-cache'
    response.status = 200
  end
end
