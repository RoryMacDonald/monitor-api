class LocalAuthority::UseCase::CreateReturn
  def initialize(return_gateway:, return_update_gateway:, find_project:)
    @return_gateway = return_gateway
    @return_update_gateway = return_update_gateway
    @find_project = find_project
  end

  def execute(project_id:, data:)
    project = @find_project.execute(id: project_id)
    created_return_id = create_return_for_project(project_id, project[:type], project[:version])
    create_return_update(created_return_id, data)

    { id: created_return_id }
  end

  private

  def create_return_for_project(project_id, type, version)
    return_object = LocalAuthority::Domain::Return.new.tap do |r|
      r.project_id = project_id
      r.baseline_version = version
    end

    @return_gateway.create(return_object)
  end

  def create_return_update(return_id, data)
    return_update = LocalAuthority::Domain::ReturnUpdate.new.tap do |u|
      u.return_id = return_id
      u.data = data
    end

    @return_update_gateway.create(return_update)
  end
end
