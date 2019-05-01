class UI::UseCase::UpdateMonthlyCatchup

  def initialize(convert_ui_monthly_catchup:, find_project:, update_monthly_catchup:)
    @convert_ui_monthly_catchup = convert_ui_monthly_catchup
    @find_project = find_project
    @update_monthly_catchup = update_monthly_catchup
  end

  def execute(project_id:, monthly_catchup_id:, monthly_catchup_data:)
    project = @find_project.execute(id: project_id)
    converted_ui_data = @convert_ui_monthly_catchup.execute(type: project[:type], monthly_catchup_data: monthly_catchup_data)
    @update_monthly_catchup.execute(monthly_catchup_id: monthly_catchup_id, monthly_catchup_data: converted_ui_data)
  end
end
