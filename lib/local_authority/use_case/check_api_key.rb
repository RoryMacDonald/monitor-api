class LocalAuthority::UseCase::CheckApiKey
  def initialize(get_user_projects:, user_gateway:)
    @get_user_projects = get_user_projects
    @user_gateway = user_gateway
  end

  def execute(api_key:, project_id:)
    project_id = project_id.to_i unless project_id.nil?

    begin
      payload = get_payload(api_key)
      api_key_email = payload['email']
      api_key_role = @user_gateway.find_by(email: api_key_email).role
      user_projects = @get_user_projects.execute(email: api_key_email)[:project_list]

      if project_id.nil?
        { valid: true, email: api_key_email, role: api_key_role }
      elsif has_permission_for_project?(project_id, user_projects)
        { valid: true, email: api_key_email, role: api_key_role }
      else
        { valid: false }
      end
    rescue JWT::DecodeError
      { valid: false }
    end
  end

  private

  def get_payload(api_key)
    JWT.decode(
      api_key,
      ENV['HMAC_SECRET'],
      true,
      algorithm: 'HS512'
    )[0]
  end

  def has_permission_for_project?(project_id, user_projects)
    user_projects.any? { |p| p[:id] == project_id }
  end
end
