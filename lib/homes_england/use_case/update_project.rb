class HomesEngland::UseCase::UpdateProject
  def initialize(baseline_gateway:)
    @baseline_gateway = baseline_gateway
  end

  def execute(project_id:, project_data:, timestamp:)
    current_baseline = @baseline_gateway.versions_for(project_id: project_id).last

    return { successful: false, errors: [:incorrect_timestamp], timestamp: timestamp } unless valid_timestamps?(current_baseline.timestamp, timestamp)
    current_time = Time.now.to_i
    current_baseline.data = project_data
    current_baseline.status = 'Draft'
    current_baseline.timestamp = current_time

    successful = @baseline_gateway.update(id: current_baseline.id, baseline: current_baseline)[:success]

    { successful: true, errors: [], timestamp:  current_time}
  end

  private

  def valid_timestamps?(saved_timestamp, new_timestamp)
    saved_timestamp == new_timestamp || saved_timestamp.zero?
  end
end
