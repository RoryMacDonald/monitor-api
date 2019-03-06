class HomesEngland::UseCase::AmendBaseline
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, data:, timestamp:)
    found_project = @project_gateway.find_by(id: project_id)
    
    return { success: false, errors: [:incorrect_timestamp] } if timestamp < found_project.timestamp

    project = HomesEngland::Domain::Project.new.tap do |project|
      project.version = found_project.version + 1
      project.data = data

      project.name = found_project.name
      project.type = found_project.type
      project.status = found_project.status
      project.timestamp = Time.now.to_i
      project.bid_id = found_project.bid_id
    end
    @project_gateway.update(id: project_id, project: project)

    { success: true }
  end
end