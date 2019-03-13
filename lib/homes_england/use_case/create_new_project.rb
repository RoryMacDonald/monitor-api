# frozen_string_literal: true

class HomesEngland::UseCase::CreateNewProject
  def initialize(project_gateway:, baseline_gateway:)
    @project_gateway = project_gateway
    @baseline_gateway = baseline_gateway
  end

  def execute(name:, type:, baseline:, bid_id:)
    project = HomesEngland::Domain::Project.new.tap do |proj|
      proj.name = name
      proj.type = type
      proj.status = 'Draft'
      proj.bid_id = bid_id
    end

    id = @project_gateway.create(project)
    
    new_baseline = HomesEngland::Domain::Baseline.new.tap do |base|
      base.project_id = id
      base.data = baseline
      base.status = 'Draft'
      base.version = 1
    end

    @baseline_gateway.create(new_baseline)

    { id: id }
  end
end
