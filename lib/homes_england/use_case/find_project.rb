class HomesEngland::UseCase::FindProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(id:)
    project = @project_gateway.find_by(id: id)
    {
      name: project.name,
      type: project.type,
      data: project.data,
      status: project.status,
      bid_id: project.bid_id,
      timestamp: project.timestamp
    }
  end
end
