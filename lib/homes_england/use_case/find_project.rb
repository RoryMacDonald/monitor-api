class HomesEngland::UseCase::FindProject
  def initialize(project_gateway:, baseline_gateway:)
    @project_gateway = project_gateway
    @baseline_gateway = baseline_gateway
  end

  def execute(id:)
    project = @project_gateway.find_by(id: id)

    baseline = get_baseline_data(id, project.status)

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

  private

  def get_baseline_data(id, project_status)
    baselines = @baseline_gateway.versions_for(project_id: id)
    baselines.select! { |b| b.status == 'Submitted' } if project_status == 'Submitted'

    baselines.last
  end
end
