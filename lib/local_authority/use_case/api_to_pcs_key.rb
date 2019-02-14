class LocalAuthority::UseCase::ApiToPcsKey
  def execute(api_key:)
    payload = get_payload(api_key)
    {pcs_key: JWT.encode(payload, ENV['PCS_SECRET'], 'HS512') }
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
