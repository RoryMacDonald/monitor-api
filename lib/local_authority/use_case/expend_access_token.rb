# frozen_string_literal: true

class LocalAuthority::UseCase::ExpendAccessToken
  def initialize(access_token_gateway:, create_api_key:)
    @access_token_gateway = access_token_gateway
    @create_api_key = create_api_key
  end

  def execute(access_token:, project_id: nil)
    access_token = @access_token_gateway.find_by(uuid: access_token)
    return { status: :failure, api_key: '' } unless access_token

    if access_token.projects.include?(project_id) || project_id.nil?
      api_key = @create_api_key.execute(projects: access_token.projects, email: access_token.email, role: access_token.role)[:api_key]
      @access_token_gateway.delete(uuid: access_token.uuid)
      { status: :success, api_key: api_key, role: access_token.role }
    else
      { status: :failure, api_key: '' }
    end
  end
end
