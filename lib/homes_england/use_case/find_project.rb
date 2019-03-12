class HomesEngland::UseCase::FindProject
  def initialize(project_gateway:, baseline_gateway:)
    @project_gateway = project_gateway
    @baseline_gateway = baseline_gateway
  end

  def execute(id:)
    baseline = @baseline_gateway.versions_for(project_id: id).last

    project = @project_gateway.find_by(id: id)
    {
      name: project.name,
      type: project.type,
      data: baseline.data,
      status: project.status,
      bid_id: project.bid_id,
      version: baseline.version,
      timestamp: baseline.timestamp
    }
  end
end
