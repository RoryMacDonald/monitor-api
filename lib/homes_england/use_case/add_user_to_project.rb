class HomesEngland::UseCase::AddUserToProject
  def initialize(user_gateway:, project_gateway:)
    @user_gateway = user_gateway
    @project_gateway = project_gateway
  end

  def execute(email:, role: nil, project_id:)
    projects = @project_gateway.all.each do |project|
      next if project_id != project.id

      user = @user_gateway.find_by(email: email)
      if user.nil?
        user = LocalAuthority::Domain::User.new.tap do |u|
          u.email = email.downcase
          u.role = role
          u.projects = [project_id]
        end
        @user_gateway.create(user)
      else
        user.projects << project_id
        @user_gateway.update(user)
      end
    end
  end
end
