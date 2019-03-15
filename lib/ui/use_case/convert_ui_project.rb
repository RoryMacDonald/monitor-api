# frozen_string_literal: true

class UI::UseCase::ConvertUIProject
  def initialize(convert_ui_hif_project:, convert_ui_ac_project:, convert_ui_ff_project:)
    @convert_ui_hif_project = convert_ui_hif_project
    @convert_ui_ac_project = convert_ui_ac_project
    @convert_ui_ff_project = convert_ui_ff_project
  end

  def execute(project_data:, type: nil)
    project_data = @convert_ui_hif_project.execute(project_data: project_data) if type == 'hif'
    project_data = @convert_ui_ac_project.execute(project_data: project_data) if type == 'ac'
    project_data = @convert_ui_ff_project.execute(project_data: project_data) if type == 'ff'
    
    compact(project_data)
  end

  private

  def compact(data)  
    if complex_object?(data)
      data.compact!
      data.each do |value|
        compact(value)
      end
    end
  end

  def complex_object?(obj)
    (obj.class == Hash || obj.class == Array)
  end
end
