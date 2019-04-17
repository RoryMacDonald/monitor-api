class HomesEngland::UseCase::ChangeUserRole
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(email:, role:)
    @user_gateway.find_by(email: email).then do |user|
      user.role = role
      @user_gateway.update(user)
    end
  end
end
