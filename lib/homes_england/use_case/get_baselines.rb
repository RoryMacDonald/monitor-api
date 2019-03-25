class HomesEngland::UseCase::GetBaselines
  def initialize(baseline_gateway:)
    @baseline_gateway = baseline_gateway
  end

  def execute(project_id:)    
    baselines = @baseline_gateway.versions_for(project_id: project_id).map do |baseline|
      {
        data: baseline.data,
        version: baseline.version,
        status: baseline.status,
        id: baseline.id,
        timestamp: baseline.timestamp
      }
    end

    { baselines: baselines }
  end
end
