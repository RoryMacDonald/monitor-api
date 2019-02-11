# frozen_string_literal: true

require 'securerandom'

class LocalAuthority::UseCase::CreateAccessToken
  def initialize(access_token_gateway:, user_gateway:)
    @access_token_gateway = access_token_gateway
    @user_gateway = user_gateway
  end

  def execute(email:)
    found_user = @user_gateway.find_by(email: email)
    return {status: :failure} if found_user.nil?

    access_token = LocalAuthority::Domain::AccessToken.new.tap do |token|
      token.uuid = SecureRandom.uuid
      token.projects = found_user.projects
      token.email = email
      token.role = found_user.role
    end
    @access_token_gateway.create(access_token)
    { status: :success, access_token: access_token.uuid }
  end
end
