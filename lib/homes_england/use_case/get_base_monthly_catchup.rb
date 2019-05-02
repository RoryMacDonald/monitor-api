class HomesEngland::UseCase::GetBaseMonthlyCatchup
  def initialize(find_project:, monthly_catchup_template_gateway:)
    @find_project = find_project
    @monthly_catchup_template_gateway = monthly_catchup_template_gateway
  end

  def execute(project_id:)
    project = @find_project.execute(id: project_id)
    template = @monthly_catchup_template_gateway.execute(type: project[:type])
    {
      base_monthly_catchup: {
        project_id: project_id,
        data: {},
        schema: template.schema
      }
    }
  end
end
