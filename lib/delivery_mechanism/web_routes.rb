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

    get '/baseline/:type' do
      schema = @dependency_factory.get_use_case(:get_schema_for_project).execute(type: params['type'])
      return 404 if schema.nil?
      response.body = schema.to_json
      response.headers['Cache-Control'] = 'no-cache'
      response.status = 200
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

    post '/token/expend' do
      request_hash = get_hash(request)
      expend_response = @dependency_factory.get_use_case(:expend_access_token).execute(
        access_token: request_hash[:access_token]
      )
      status = expend_response[:status]
      if status == :success
        response.status = 202
        response.body = { apiKey: expend_response[:api_key], role: expend_response[:role] }.to_json
      else
        response.status = 401
      end
    end

    get '/user/projects' do
      guard_access env, params, request do |_|
        email = @dependency_factory.get_use_case(:check_api_key).execute(
          api_key: env['HTTP_API_KEY'],
          project_id: nil
          )[:email]
          
        project_list = @dependency_factory.get_use_case(:get_user_projects).execute(email: email)[:project_list]

        content_type 'application/json'
        response.body = {
          project_list: project_list
        }.to_json
        response.headers['Cache-Control'] = 'no-cache'
        response.status = 200
      end
    end

    post '/return/update' do
      guard_access env, params, request do |request_hash|
        if request_hash[:return_data].nil? || request_hash[:return_id].nil?
          return 400
        end

        @dependency_factory.get_use_case(:ui_update_return).execute(
          return_id: request_hash[:return_id], return_data: request_hash[:return_data]
        )

        200
      end
    end

    post '/return/create' do
      guard_access env, params, request do |request_hash|
        return_id = @dependency_factory.get_use_case(:ui_create_return).execute(
          project_id: request_hash[:project_id],
          data: request_hash[:data]
        )

        response.tap do |r|
          r.body = { id: return_id[:id] }.to_json
          r.status = 201
        end
      end
    end

    post '/return/submit' do
      guard_access env, params, request do |request_hash|
        DeliveryMechanism::Controllers::PostSubmitReturn.new(
          submit_return: @dependency_factory.get_use_case(:submit_return),
          notify_project_members_of_submission: @dependency_factory.get_use_case(:notify_project_members_of_submission),
          check_api_key: @dependency_factory.get_use_case(:check_api_key)
        ).execute(env, request, request_hash, response)
      end
    end

    get '/return/get' do
      guard_access env, params, request do |_|
        return 400 if params[:returnId].nil?
        return_id = params[:returnId].to_i

        return_hash = @dependency_factory.get_use_case(:ui_get_return).execute(id: return_id)

        return 404 if return_hash.empty?

        return_schema = @dependency_factory
                        .get_use_case(:ui_get_schema_for_return)
                        .execute(return_id: return_id)[:schema]

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

    post '/return/validate' do
      guard_access env, params, request do |request_hash|
        return 400 if invalid_validation_hash(request_hash: request_hash)

        validate_response = @dependency_factory.get_use_case(:ui_validate_return).execute(
          type: request_hash[:type],
          return_data: request_hash[:data]
        )

        response.status = 200
        response.body = {
          valid: validate_response[:valid],
          invalidPaths: validate_response[:invalid_paths],
          prettyInvalidPaths: validate_response[:pretty_invalid_paths]
        }.to_json
      end
    end

    get '/projects/export' do
      response.body = {}.to_json
      guard_bi_access env, params, request do |_request_hash|
        {
          projects:
            @dependency_factory.get_use_case(:export_all_projects).execute[:compiled_projects]
        }.to_json
      end
    end

    get '/project/:id/export' do
      response.body = {}.to_json
      guard_bi_access env, params, request do |_request_hash|
        exported_project_hash = @dependency_factory.get_use_case(:export_project_data).execute(
          project_id: params['id'].to_i
        )

        if exported_project_hash.empty?
          response.status = 404
          response.body = {}.to_json
        else
          exported_project_hash[:compiled_project].to_json
        end
      end
    end

    get '/project/:id/return' do
      guard_access env, params, request do |_request_hash|
        return 400 if params['id'].nil?

        base_return = @dependency_factory.get_use_case(:ui_get_base_return).execute(
          project_id: params['id'].to_i
        )

        if base_return.empty?
          response.status = 404
        else
          response.headers['Cache-Control'] = 'no-cache'
          response.status = 200
          response.body = { baseReturn: base_return[:base_return] }.to_json
        end
      end
    end

    get '/project/:id/returns' do
      guard_access env, params, request do |_|
        returns = @dependency_factory.get_use_case(:ui_get_returns).execute(project_id: params['id'].to_i)
        response.headers['Cache-Control'] = 'no-cache'
        response.status = returns.empty? ? 404 : 200
        response.body = returns.to_json
      end
    end

    get '/project/find' do
      guard_access env, params, request do |_|
        return 404 if params['id'].nil?
        project = @dependency_factory.get_use_case(:ui_get_project).execute(id: params['id'].to_i)

        return 404 if project.nil?

        content_type 'application/json'
        response.body = {
          type: project[:type],
          status: project[:status],
          data: Common::DeepCamelizeKeys.to_camelized_hash(project[:data]),
          schema: project[:schema],
          timestamp: project[:timestamp]
        }.to_json
        response.headers['Cache-Control'] = 'no-cache'
        response.status = 200
      end
    end

    post '/project/create' do
      guard_admin_access env, params, request do |request_hash|
        contoller = DeliveryMechanism::Controllers::PostCreateProject.new(
          create_new_project: @dependency_factory.get_use_case(:ui_create_project)
        )

        content_type 'application/json'

        contoller.execute(params, request_hash, response)
      end
    end

    post '/project/:id/add_users' do
      guard_admin_access env, params, request do |request_hash|
        controller = DeliveryMechanism::Controllers::PostProjectToUsers.new(
          add_user_to_project: @dependency_factory.get_use_case(:add_user_to_project)
        )
        controller.execute(params, request_hash, response)
      end
    end

    post '/project/update' do
      guard_access env, params, request do |request_hash|
        if valid_update_request_body(request_hash)
          get_project_use_case = @dependency_factory.get_use_case(:ui_get_project)
          project = get_project_use_case.execute(id: request_hash[:project_id].to_i )
          use_case = @dependency_factory.get_use_case(:ui_update_project)

          update_response = use_case.execute(
            id: request_hash[:project_id].to_i,
            type: project[:type],
            data: request_hash[:project_data],
            timestamp: request_hash[:timestamp].to_i
          )

          response.status = update_successful?(update_response) ? 200 : 404
          response.body = { errors: update_response[:errors], timestamp: update_response[:timestamp] }.to_json
        else
          response.status = 400
        end
      end
    end

    def update_successful?(update_response)
      update_response[:successful] || !update_response[:errors].empty?
    end

    post '/project/validate' do
      guard_access env, params, request do |request_hash|
        return 400 if invalid_validation_hash(request_hash: request_hash)

        validate_response = @dependency_factory.get_use_case(:ui_validate_project).execute(
          type: request_hash[:type],
          project_data: request_hash[:data]
        )

        response.status = 200
        response.body = {
          valid: validate_response[:valid],
          invalidPaths: validate_response[:invalid_paths],
          prettyInvalidPaths: validate_response[:pretty_invalid_paths]
        }.to_json
      end
    end

    post '/project/submit' do
      guard_access env, params, request do |request_hash|
        @dependency_factory.get_use_case(:submit_project).execute(
          project_id: request_hash[:project_id].to_i
        )

        @dependency_factory.get_use_case(:notify_project_members_of_creation).execute(project_id: request_hash[:project_id].to_i, url: request_hash[:url])

        response.status = 200
      end
    end

    unless ENV['BACK_TO_BASELINE'].nil?
      post '/project/unsubmit' do
        guard_access env, params, request do |request_hash|
          @dependency_factory.get_use_case(:unsubmit_project).execute(
            project_id: request_hash[:project_id].to_i
          )

          response.status = 200
        end
      end
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
      access_status = get_access_status(env, params, request_hash)

      if access_status == :bad_request
        response.status = 400
      elsif access_status == :forbidden
        response.status = 401
      else
        yield request_hash
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
      elsif !@dependency_factory.get_use_case(:check_api_key).execute(
        api_key: env['HTTP_API_KEY'],
        project_id: request_hash[:project_id]
      )[:valid]
        :forbidden
      else
        :proceed
      end
    end

    def check_get_access(env, params)
      if env['HTTP_API_KEY'].nil? 
        :bad_request
      elsif !@dependency_factory.get_use_case(:check_api_key).execute(
          api_key: env['HTTP_API_KEY'],
          project_id: params['id']
        )[:valid]
          :forbidden
      else
        :proceed
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
