class UI::UseCase::GetBaselines
  def initialize(get_baselines:, convert_core_project:, find_project:)
    @get_baselines = get_baselines
    @convert_core_project = convert_core_project
    @find_project = find_project
  end

  def execute(project_id:)
    type = @find_project.execute(id: project_id)[:type]
    baselines = @get_baselines.execute(project_id: project_id)[:baselines]
    baselines.each do |baseline|
      baseline[:data] = @convert_core_project.execute(type: type, data: baseline[:data])
    end

    { baselines: baselines }

  end
end

