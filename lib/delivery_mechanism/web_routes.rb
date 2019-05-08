# frozen_string_literal: true

require 'sinatra'

module DeliveryMechanism
  class WebRoutes < Sinatra::Base
    before do
      @dependency_factory = Dependencies.dependency_factory
    end

    after do
      @dependency_factory.database.disconnect
      set_cors_header(response)
    end

    options '*' do
      response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, API_KEY'
      200
    end

    post '/token/request' do
      request_hash = get_hash(request)

      controller = DeliveryMechanism::Controllers::PostRequestToken.new(
        check_email: @dependency_factory.get_use_case(:check_email),
        send_notification: @dependency_factory.get_use_case(:send_notification),
        create_access_token: @dependency_factory.get_use_case(:create_access_token)
      )

      controller.execute(request_hash, response)
    end

    post '/project/create' do
      guard_access env, params, request do |request_hash|

        controller = DeliveryMechanism::Controllers::PostCreateProject.new(
          create_new_project: @dependency_factory.get_use_case(:ui_create_project)
        )

        content_type 'application/json'

        controller.execute(params, request_hash, response)
      end
    end

    post '/project/admin/create' do
      guard_admin_access env, params, request do |request_hash|
        controller = DeliveryMechanism::Controllers::PostCreateProject.new(
          create_new_project: @dependency_factory.get_use_case(:ui_create_project)
        )

        content_type 'application/json'

        controller.execute(params, request_hash, response)
      end
    end

    def update_successful?(update_response)
      update_response[:successful] || !update_response[:errors].empty?
    end

    def get_hash(request)
      body = request.body.read
      return nil if body.to_s.empty?
      request_json = JSON.parse(body)
      Common::DeepSymbolizeKeys.to_symbolized_hash(request_json)
    end

    def guard_admin_access(env, _params, request)
      return 401 if authorization_header_not_present?
      admin_auth_key = env['HTTP_API_KEY']

      if valid_admin_api_key?(key: admin_auth_key)
        request_hash = get_hash(request)
        yield request_hash
      else
        response.status = 401
      end
    end

    def guard_bi_access(env, _params, request)
      return 401 if authorization_header_not_present?
      bi_auth_key = env['HTTP_API_KEY']

      if valid_bi_api_key?(key: bi_auth_key)
        request_hash = get_hash(request)
        yield request_hash
      else
        response.status = 401
      end
    end

    def guard_access(env, params, request)
      request_hash = get_hash(request)
      access_status, user_info = get_access_status(env, params, request_hash)

      if access_status == :bad_request
        response.status = 400
      elsif access_status == :forbidden
        response.status = 401
      else
        yield request_hash, user_info
      end
    end

    def get_access_status(env, params, request_hash)
      if request.request_method == 'POST'
        check_post_access(env, request_hash)
      else
        check_get_access(env, params)
      end
    end

    def check_post_access(env, request_hash)
      if env['HTTP_API_KEY'].nil? || request_hash.nil?
        :bad_request
      else
        user_info = @dependency_factory.get_use_case(:check_api_key).execute(
          api_key: env['HTTP_API_KEY'],
          project_id: request_hash[:project_id]
        )
        if user_info[:valid]
          [:proceed, user_info]
        else
          :forbidden
        end
      end
    end

    def check_get_access(env, params)
      if env['HTTP_API_KEY'].nil?
        :bad_request
      else
        user_info = @dependency_factory.get_use_case(:check_api_key).execute(
          api_key: env['HTTP_API_KEY'],
          project_id: params['id']
        )
        if user_info[:valid]
          [:proceed, user_info]
        else
          :forbidden
        end
      end
    end

    private

    def invalid_validation_hash(request_hash:)
      request_hash.nil? || request_hash.key?(:type) == false || request_hash.key?(:data) == false
    end

    def authorization_header_not_present?
      env['HTTP_API_KEY'].nil?
    end

    def valid_admin_api_key?(key:)
      return false unless key == ENV['ADMIN_HTTP_API_KEY']
      true
    end

    def valid_bi_api_key?(key:)
      return false unless key == ENV['BI_HTTP_API_KEY']
      true
    end

    def valid_update_request_body(request_body)
      !request_body.dig(:project_id).nil? &&
        !request_body.dig(:project_data).nil?
    end

    def set_cors_header(response)
      response.headers['Access-Control-Allow-Origin'] ||= get_cors_header()
    end

    def get_cors_header()
      ENV['CORS_ORIGIN'] || '*'
    end

  end
end
