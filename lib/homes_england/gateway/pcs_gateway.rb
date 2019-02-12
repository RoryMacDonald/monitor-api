require "erb"

class HomesEngland::Gateway::Pcs
  def initialize
    @pcs_url = ENV['PCS_URL']
  end

  def get_project(bid_id:, api_key:)
    received_project = request_project(bid_id, api_key)

    HomesEngland::Domain::PcsBid.new.tap do |project|
      project.project_manager = received_project["ProjectManager"]
      project.sponsor = received_project["Sponsor"]
    end
  end

  def request_project(bid_id, api_key)
    pcs_endpoint = Net::HTTP.new(@pcs_url)
    request = Net::HTTP::Get.new("/project/#{ERB::Util.url_encode(bid_id)}")
    request['Authorization'] = "Bearer #{api_key}"
    response = pcs_endpoint.request(request)
    received_json = JSON.parse(response.body)
  end
end
