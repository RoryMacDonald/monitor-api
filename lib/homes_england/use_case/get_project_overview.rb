class HomesEngland::UseCase::GetProjectOverview
  def initialize(
    baseline_gateway:,
    claim_gateway:,
    find_project:,
    return_gateway:
  )
    @claim_gateway = claim_gateway
    @baseline_gateway = baseline_gateway
    @find_project = find_project
    @return_gateway = return_gateway
  end

  def execute(id:)
    project = @find_project.execute(id: id)
    claims = @claim_gateway.get_all(project_id: id)
    returns = @return_gateway.get_returns(project_id: id)
    baselines = @baseline_gateway.versions_for(project_id: id)

    {
      name: project[:name],
      status: project[:status],
      type: project[:type],
      data: project[:data],
      returns: returns.map { |r| { id: r.id, status: r.status } },
      claims: claims.map { |c| { id: c.id, status: c.status } },
      baselines: baselines.map { |b| { id: b.id, status: b.status } }
    }
  end
end
