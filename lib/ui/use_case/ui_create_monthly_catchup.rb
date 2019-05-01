class UI::UseCase::UiCreateMonthlyCatchup

  def initialize(convert_ui_monthly_catchup:, create_monthly_catchup:, find_project:)
    @find_project = find_project
    @convert_ui_monthly_catchup = convert_ui_monthly_catchup
    @create_monthly_catchup = create_monthly_catchup
  end

  def execute(project_id:, monthly_catchup_data:)
    project = @find_project.execute(id: project_id)
    monthly_catchup_data = @convert_ui_monthly_catchup.execute(monthly_catchup_data: monthly_catchup_data, type: project[:type])
    response = @create_monthly_catchup.execute(project_id: project_id, monthly_catchup_data: monthly_catchup_data)
    {
      id: response[:id]
    }
  end
end
