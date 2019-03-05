# frozen_string_literal: true

require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/project/admin/:id/add_users' do
  guard_admin_access env, params, request do |request_hash|
    controller = DeliveryMechanism::Controllers::PostProjectToUsers.new(
      add_user_to_project: @dependency_factory.get_use_case(:add_user_to_project)
    )
    controller.execute(params, request_hash, response)
  end
end
