# frozen_string_literal: true

class UI::UseCase::CreateProject
  def initialize(create_project:, convert_ui_project:)
    @create_project = create_project
    @convert_ui_project = convert_ui_project
  end

  def execute(type:, name:, baseline:, bid_id:)
    baseline = @convert_ui_project.execute(project_data: baseline, type: type)

    created_id = @create_project.execute(
      type: type,
      name: name,
      baseline: baseline,
      bid_id: bid_id
    )[:id]

    { id: created_id }
  end
end
