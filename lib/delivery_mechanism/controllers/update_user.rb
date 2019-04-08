require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/admin/user/role' do
  guard_admin_access env, params, request do |request_hash|
    return 400 if request_hash[:email].nil? || request_hash[:role].nil?

    @dependency_factory
      .get_use_case(:change_user_role)
      .execute(email: request_hash[:email], role: request_hash[:role])
  end
end
