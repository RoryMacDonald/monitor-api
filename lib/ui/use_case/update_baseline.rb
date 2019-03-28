# frozen_string_literal: true

class UI::UseCase::UpdateBaseline
  def initialize(update_baseline:, convert_ui_project:)
    @update_baseline= update_baseline
    @convert_ui_project = convert_ui_project
  end
  
  def execute(id:, data:, timestamp:, type: nil)
    data = @convert_ui_project.execute(project_data: data, type: type)
 
    response = @update_baseline.execute(
      project_id: id,
      project_data: data,
      timestamp: timestamp
    )

    { successful: response[:successful], errors: response[:errors], timestamp: response[:timestamp] }
  end
end
