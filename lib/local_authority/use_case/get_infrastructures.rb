class LocalAuthority::UseCase::GetInfrastructures
  def initialize(find_project:)
    @find_project = find_project
  end

  def execute(project_id:)
    project = @find_project.execute(id: project_id)

    if project[:type] == 'ff'
      infrastructures = project.dig(:data, :infrastructures)
      { infrastructures: infrastructures }
    else
      {}
    end
  end
end
