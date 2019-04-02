class HomesEngland::UseCase::UpdateProject
  def initialize(baseline_gateway:)
    @baseline_gateway = baseline_gateway
  end

  def execute(project_id:, project_data:, timestamp:)
    current_baseline = @baseline_gateway.versions_for(project_id: project_id).last

    return project_already_submitted_response unless current_baseline.status != 'Submitted'
    return incorrect_timestamp_response(timestamp) unless valid_timestamps?(current_baseline.timestamp, timestamp)

    current_time = Time.now.to_i
    current_baseline.data = project_data
    current_baseline.status = 'Draft'
    current_baseline.timestamp = current_time

    @baseline_gateway.update(id: current_baseline.id, baseline: current_baseline)

    { successful: true, errors: [], timestamp: current_time }
  end

  private

  def incorrect_timestamp_response(timestamp)
    { successful: false, errors: [:incorrect_timestamp], timestamp: timestamp }
  end

  def project_already_submitted_response
    { successful: false, errors: [:project_already_submitted] }
  end

  def valid_timestamps?(saved_timestamp, new_timestamp)
    saved_timestamp == new_timestamp || saved_timestamp.zero?
  end
end
