class HomesEngland::Gateway::Pcs
  def initialize
    @pcs_url = ENV['PCS_URL']
  end

  def get_project(bid_id:)
    received_project = request_project(bid_id)

    HomesEngland::Domain::PcsBid.new.tap do |project|
      project.project_manager = received_project["ProjectManager"]
      project.sponsor = received_project["Sponsor"]
    end
  end

  def request_project(bid_id)
    response = Net::HTTP.get(@pcs_url,"/project/#{bid_id}")
    received_json = JSON.parse(response)
  end
end
