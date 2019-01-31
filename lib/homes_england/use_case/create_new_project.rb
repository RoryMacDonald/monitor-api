# frozen_string_literal: true

class HomesEngland::UseCase::CreateNewProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(name:, type:, baseline:, bid_id:)
    project = HomesEngland::Domain::Project.new
    project.name = name
    project.type = type
    project.data = baseline
    project.status = 'Draft'
    project.bid_id = bid_id

    id = @project_gateway.create(project)

    { id: id }
  end
end
