class HomesEngland::UseCase::PopulateBaseline
  def initialize(find_project:, pcs_gateway:)
    @pcs_gateway = pcs_gateway
    @find_project = find_project
  end

  def execute(project_id:)
    project_data = @find_project.execute(id: project_id)
    
    return project_data if project_data[:bid_id].nil?
    
    project_data[:data][:summary] = {} if project_data[:data][:summary].nil?
    project_data[:data][:summary][:BIDReference] = project_data[:bid_id]

    project_data[:admin_data] = {} if project_data[:admin_data].nil?
    project_data[:admin_data][:projectDetails] = {} if project_data[:admin_data][:projectDetails].nil?
    project_data[:admin_data][:projectDetails][:BIDReference] = project_data[:bid_id]
    
    
    unless ENV['PCS'].nil?
      pcs_data = @pcs_gateway.get_project(bid_id: project_data[:bid_id])
      
      if pcs_data
        project_data[:data][:summary][:projectManager] = pcs_data.project_manager
        project_data[:data][:summary][:sponsor] = pcs_data.sponsor
      end
    end

    project_data
  end
end
