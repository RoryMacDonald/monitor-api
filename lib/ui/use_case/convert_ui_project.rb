# frozen_string_literal: true

class UI::UseCase::ConvertUIProject
  def initialize(convert_ui_hif_project:, convert_ui_ac_project:, convert_ui_ff_project:, sanitise_data:)
    @convert_ui_hif_project = convert_ui_hif_project
    @convert_ui_ac_project = convert_ui_ac_project
    @convert_ui_ff_project = convert_ui_ff_project
    @sanitise_data = sanitise_data
  end

  def execute(project_data:, type: nil)
    project_data = @convert_ui_hif_project.execute(project_data: project_data) if type == 'hif'
    project_data = @convert_ui_ac_project.execute(project_data: project_data) if type == 'ac'
    project_data = @convert_ui_ff_project.execute(project_data: project_data) if type == 'ff'
    
    @sanitise_data.execute(data: project_data)
  end
end
