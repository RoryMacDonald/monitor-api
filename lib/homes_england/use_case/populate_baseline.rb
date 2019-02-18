class HomesEngland::UseCase::PopulateBaseline
  def initialize(find_project:, pcs_gateway:)
    @pcs_gateway = pcs_gateway
    @find_project = find_project
  end

  def execute(project_id:, api_key:)
    project_data = @find_project.execute(id: project_id)

    unless ENV['PCS'].nil? || project_data[:bid_id].nil?
      pcs_data = @pcs_gateway.get_project(bid_id: project_data[:bid_id], api_key: api_key)

      project_data[:data][:summary] = {} if project_data[:data][:summary].nil?
      project_data[:data][:summary][:projectManager] = pcs_data.project_manager
      project_data[:data][:summary][:sponsor] = pcs_data.sponsor
    end

    project_data
  end
end
