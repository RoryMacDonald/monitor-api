# frozen_string_literal: true

class UI::UseCase::CreateProject
  def initialize(create_project:, convert_ui_project:, new_project_gateway:)
    @create_project = create_project
    @convert_ui_project = convert_ui_project
    @new_project_gateway = new_project_gateway
  end

  def execute(type:, name:, baseline:, bid_id:)
    if baseline.nil?
      baseline = @new_project_gateway.find_by(type: type)
    else
      baseline = @convert_ui_project.execute(project_data: baseline, type: type)
    end

    created_id = @create_project.execute(
      type: type,
      name: name,
      baseline: baseline,
      bid_id: bid_id
    )[:id]

    { id: created_id }
  end
end
