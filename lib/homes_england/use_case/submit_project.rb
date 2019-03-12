# frozen_string_literal: true

class HomesEngland::UseCase::SubmitProject
  def initialize(project_gateway:, baseline_gateway:)
    @project_gateway = project_gateway
    @baseline_gateway = baseline_gateway
  end

  def execute(project_id:)
    baseline_id = @baseline_gateway.versions_for(project_id: project_id).last.id
    @baseline_gateway.submit(id: baseline_id)
    @project_gateway.submit(id: project_id, status: 'Submitted')
  end
end
