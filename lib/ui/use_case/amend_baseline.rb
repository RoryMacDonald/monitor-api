# frozen_string_literal: true

class UI::UseCase::AmendBaseline
  def initialize(amend_baseline:, convert_ui_project:, find_project:)
    @amend_baseline = amend_baseline
    @convert_ui_project = convert_ui_project
    @find_project = find_project
  end

  def execute(project_id:, data:, timestamp:)
    type = @find_project.execute(id: project_id)[:type]
    data = @convert_ui_project.execute(project_data: data, type: type)
    
    @amend_baseline.execute(
      project_id: project_id,
      data: data,
      timestamp: timestamp
    )
  end
end