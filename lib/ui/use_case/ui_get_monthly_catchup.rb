class UI::UseCase::UiGetMonthlyCatchup
  def initialize(convert_core_monthly_catchup:, get_monthly_catchup:, find_project:, catchup_schema_gateway:)
    @find_project = find_project
    @get_monthly_catchup = get_monthly_catchup
    @convert_core_monthly_catchup = convert_core_monthly_catchup
    @catchup_schema_gateway = catchup_schema_gateway
  end

  def execute(project_id:, monthly_catchup_id:)
    project = @find_project.execute(id: project_id)
    schema = @catchup_schema_gateway.find_by(type: project[:type])
    monthly_catchup = @get_monthly_catchup.execute(monthly_catchup_id: monthly_catchup_id)
    monthly_catchup_data = @convert_core_monthly_catchup.execute(type: project[:type], monthly_catchup_data: monthly_catchup[:data])

    {
      id: monthly_catchup[:id],
      project_id: project_id,
      data: monthly_catchup_data,
      status: monthly_catchup[:status],
      schema: schema.schema
    }
  end
end
