class LocalAuthority::UseCase::GetInfrastructures
  def initialize(find_project:)
    @find_project = find_project
  end

  def execute(project_id:)
    project = @find_project.execute(id: project_id)

    if project[:type] == 'ff'
      infrastructures = project.dig(:data, :infrastructures)
      { infrastructures: collate_infrastructures(infrastructures) }
    else
      {}
    end
  end

  private

  def collate_infrastructures(infrastructures)
    @current_ids = 0
    return nil unless infrastructures

    infrastructures[:HIFFunded] = add_type(infrastructures[:HIFFunded], 'hif')
    infrastructures[:widerProject] = add_type(infrastructures[:widerProject], 'wider_project')
    add_ids(infrastructures)
  end

  def add_type(infrastructures, type)
    return unless infrastructures
    infrastructures.map do |infrastructure|
      infrastructure[:type] = type
      infrastructure
    end
  end

  def add_ids(infrastructures)
    @current_ids = []
    get_current_ids(infrastructures[:HIFFunded])
    get_current_ids(infrastructures[:widerProject])

    add_new_ids(infrastructures[:HIFFunded])
    add_new_ids(infrastructures[:widerProject])

    infrastructures.compact
  end

  def add_new_ids(infrastructures)
    return unless infrastructures
    infrastructures.map! do |infra|
      unless infra[:id]
        infra[:id] = @current_ids.max.to_i + 1
        @current_ids.push(infra[:id])
      end
      infra
    end
  end

  def get_current_ids(infrastructures)
    return unless infrastructures
    infrastructures.each do |infra| 
      @current_ids.push(infra[:id]) if infra[:id]
    end
  end
end
