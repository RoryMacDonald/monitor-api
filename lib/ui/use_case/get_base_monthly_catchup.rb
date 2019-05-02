class UI::UseCase::GetBaseMonthlyCatchup
  def initialize(get_base_monthly_catchup:, convert_core_monthly_catchup:, monthly_catchup_schema_gateway:, find_project:)
    @get_base_monthly_catchup = get_base_monthly_catchup
    @convert_core_monthly_catchup = convert_core_monthly_catchup
    @monthly_catchup_schema_gateway = monthly_catchup_schema_gateway
    @find_project = find_project
  end

  def execute(project_id:)
    project = @find_project.execute(id: project_id)
    type = project[:type]
    base_monthly_catchup = @get_base_monthly_catchup.execute(project_id: project_id)[:base_monthly_catchup]
    data = @convert_core_monthly_catchup.execute(type: type, monthly_catchup_data: base_monthly_catchup[:data])
    template = @monthly_catchup_schema_gateway.find_by(type: type)

    {
      project_id: project_id,
      schema: template.schema,
      data: data
    }
  end
end
