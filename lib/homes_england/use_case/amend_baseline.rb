class HomesEngland::UseCase::AmendBaseline
  def initialize(project_gateway:, baseline_gateway:)
    @project_gateway = project_gateway
    @baseline_gateway = baseline_gateway
  end

  def execute(project_id:)
    last_version = @baseline_gateway.versions_for(project_id: project_id).last

    new_baseline = HomesEngland::Domain::Baseline.new.tap do |baseline|
      baseline.version = last_version.version + 1
      baseline.data = last_version.data
      baseline.project_id = project_id
      baseline.status = 'Draft'
      baseline.timestamp = Time.now.to_i
    end

    id = @baseline_gateway.create(new_baseline)

    { success: true, id: id, timestamp: new_baseline.timestamp, errors: [] }
  end
end