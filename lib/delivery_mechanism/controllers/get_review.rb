require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/review/get' do
  guard_access env, params, request do |request_hash|
    id = params['review_id'].to_i
    @dependency_factory.get_use_case(:get_rm_review).execute(id: id).then do |review|
      {
        id: review[:id],
        project_id: review[:project_id],
        data: review[:data],
        status: review[:status]
      }.to_json
    end
  end
end
