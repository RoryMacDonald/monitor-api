# frozen_string_literal: true

class UI::UseCase::GetProject
  def initialize(find_project:, convert_core_project:, project_schema_gateway:)
    @find_project = find_project
    @project_schema_gateway = project_schema_gateway
    @convert_core_project = convert_core_project
  end

  def execute(id:, pcs_key:)
    found_project = @find_project.execute(project_id: id, pcs_key: pcs_key)

    template = @project_schema_gateway.find_by(type: found_project[:type])

    found_project[:data] = @convert_core_project.execute(project_data: found_project[:data], type: found_project[:type])

    {
      name: found_project[:name],
      type: found_project[:type],
      data: found_project[:data],
      bid_id: found_project[:bid_id],
      status: found_project[:status],
      schema: template.schema,
      timestamp: found_project[:timestamp]
    }
  end
end
