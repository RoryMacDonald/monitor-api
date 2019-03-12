# frozen_string_literal: true

class HomesEngland::UseCase::CreateNewProject
  def initialize(project_gateway:, baseline_gateway:)
    @project_gateway = project_gateway
    @baseline_gateway = baseline_gateway
  end

  def execute(name:, type:, baseline:, bid_id:)
    project = HomesEngland::Domain::Project.new
    project.name = name
    project.type = type
    project.status = 'Draft'
    project.bid_id = bid_id

    id = @project_gateway.create(project)
    
    new_baseline = HomesEngland::Domain::Baseline.new
    new_baseline.project_id = id
    new_baseline.data = baseline
    new_baseline.status = 'Draft'
    new_baseline.version = 1

    @baseline_gateway.create(new_baseline)

    { id: id }
  end
end
