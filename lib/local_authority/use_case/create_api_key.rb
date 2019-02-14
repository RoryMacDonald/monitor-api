require 'date'

class LocalAuthority::UseCase::CreateApiKey
  def execute(projects:, email:, role:)
    api_key = JWT.encode(
      { projects: projects, email: email, exp: thirty_days_from_now, role: role },
      ENV['HMAC_SECRET'],
      'HS512'
    )

    { api_key: api_key }
  end

  private

  def thirty_days_from_now
    current_time_in_seconds = DateTime.now.strftime('%s').to_i
    thirty_days_in_seconds = 60 * 60 * 24 * 30

    current_time_in_seconds + thirty_days_in_seconds
  end
end
