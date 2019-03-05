require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/project/:id/add_users' do
  guard_access env, params, request do |request_hash|
    begin
      project_id = Integer(params[:id])
    rescue ArgumentError
      return 400
    end
    user_emails = request_hash[:users]

    return 400 unless user_emails.instance_of? Array

    user_emails.each do |user_info|
      @dependency_factory.get_use_case(:add_user_to_project).execute(
        {
          email: user_info[:email],
          role: user_info[:role],
          project_id: project_id
        }
      )
    end
    response.status = 200
    response
  end
end
