require "erb"

class HomesEngland::Gateway::Pcs
  def initialize
    @pcs_url = ENV['PCS_URL']
  end

  def get_project(bid_id:, pcs_key:)
    actuals_data = request_pcs_data(bid_id, '/actuals', pcs_key)
    overview_data = request_pcs_data(bid_id, '', pcs_key)

    HomesEngland::Domain::PcsBid.new.tap do |project|
      project.project_manager = overview_data[:ProjectManager]
      project.sponsor = overview_data[:Sponsor]
      project.actuals = actuals_data
    end
  end

  def request_pcs_data(bid_id, endpoint, pcs_key)
    pcs_key = "REAL API KEY"
    pcs_endpoint = Net::HTTP.new(@pcs_url, 443)
    pcs_endpoint.use_ssl = true
    request = Net::HTTP::Get.new("/pcs-api/v1/Projects/#{ERB::Util.url_encode(ERB::Util.url_encode(bid_id))}#{endpoint}")
    request['Authorization'] = "Bearer #{pcs_key}"
    response = pcs_endpoint.request(request)
    Common::DeepSymbolizeKeys.to_symbolized_hash(JSON.parse(response.body))
  end
end
