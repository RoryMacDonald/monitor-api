require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/review/get' do
  guard_access env, params, request do |request_hash|
    project_id = params['id'].to_i
    review_id = params['review_id'].to_i
    @dependency_factory.get_use_case(:ui_get_review).execute(project_id: project_id, review_id: review_id).then do |review|
      {
        id: review[:id],
        project_id: review[:project_id],
        data: review[:data],
        status: review[:status]
      }.to_json
    end
  end
end
