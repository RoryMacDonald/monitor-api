require_relative '../web_routes.rb'

DeliveryMechanism::WebRoutes.post '/return/update' do
  guard_access env, params, request do |request_hash|
    if request_hash[:return_data].nil? || request_hash[:return_id].nil?
      return 400
    end

    data = @dependency_factory.get_use_case(:sanitise_data).execute(data: request_hash[:return_data])

    @dependency_factory.get_use_case(:ui_update_return).execute(
      return_id: request_hash[:return_id], return_data: data
    )

    200
  end
end
