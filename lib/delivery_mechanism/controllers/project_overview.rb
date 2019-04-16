require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.get '/project/:id/overview' do
  guard_access env, params, request do
    project_overview = @dependency_factory.get_use_case(:get_project_overview).execute(
      id: params[:id].to_i
    )
    return 404 unless project_overview

    response.body = {
      name: project_overview[:name],
      status: project_overview[:status],
      type: project_overview[:type],
      data: project_overview[:data],
      returns: project_overview[:returns],
      baselines: project_overview[:baselines],
      claims: project_overview[:claims]
    }.to_json

    200
  end
end
