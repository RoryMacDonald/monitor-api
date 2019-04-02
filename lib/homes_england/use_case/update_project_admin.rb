class HomesEngland::UseCase::UpdateProjectAdmin
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, data:, timestamp:)
    saved_timestamp = @project_gateway.find_by(id: project_id).timestamp

    return { success: false, errors: [:incorrect_timestamp] } if timestamp > saved_timestamp

    timestamp = Time.now.to_i
    @project_gateway.update(id: project_id, data: data, timestamp: timestamp)

    { success: true, timestamp: timestamp, errors: [] }
  end
end