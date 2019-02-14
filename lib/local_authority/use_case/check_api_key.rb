class LocalAuthority::UseCase::CheckApiKey
  def execute(api_key:, project_id:)
    begin
      payload = get_payload(api_key)
      api_key_project_id = payload['project_id']
      api_key_email = payload['email']
      api_key_role = payload['role']

      if project_id == api_key_project_id
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
end
