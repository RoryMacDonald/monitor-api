# frozen_string_literal: true

class UI::UseCase::ConvertCoreFFProject
  def execute(project_data:)
    @project = project_data

    @converted_project = {}
    @converted_project[:infrastructures] = project_data[:infrastructures]

    @converted_project
  end
end
