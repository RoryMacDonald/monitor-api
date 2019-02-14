class LocalAuthority::UseCase::GetUserProjects
  def initialize(user_gateway:, project_gateway:)
    @user_gateway = user_gateway
    @project_gateway = project_gateway
  end

  def execute(email:)
    user = @user_gateway.find_by(email: email)

    projects = get_project_ids(user).map do |id|
      project_info = @project_gateway.find_by(id: id)

      {
        id: id,
        name: project_info.name,
        type: project_info.type,
        status: project_info.status
      }
    end

    { project_list: projects }

  end

  private

  def get_project_ids(user)
    user.projects.uniq
  end
end