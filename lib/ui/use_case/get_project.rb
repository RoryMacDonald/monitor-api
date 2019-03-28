# frozen_string_literal: true

class UI::UseCase::GetProject
  def initialize(find_project:, convert_core_project:, project_schema_gateway:)
    @find_project = find_project
    @project_schema_gateway = project_schema_gateway
    @convert_core_project = convert_core_project
  end

  def execute(id:)
    found_project = @find_project.execute(project_id: id)

    baseline_schema = @project_schema_gateway.find_by(type: found_project[:type]).schema
    admin_schema = @project_schema_gateway.find_by(type: found_project[:type], data: 'admin').schema

    found_project[:data] = @convert_core_project.execute(project_data: found_project[:data], type: found_project[:type])

    {
      name: found_project[:name],
      type: found_project[:type],
      data: found_project[:data],
      admin_data: found_project[:admin_data],
      bid_id: found_project[:bid_id],
      status: found_project[:status],
      schema: baseline_schema,
      admin_schema: admin_schema,
      timestamp: found_project[:timestamp]
    }
  end
end
