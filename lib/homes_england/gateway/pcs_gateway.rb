require "erb"

class HomesEngland::Gateway::Pcs
  def initialize
    @pcs_domain = ENV['PCS_DOMAIN']
  end

  def get_project(bid_id:)
    actuals_data = request_pcs_data(bid_id, '/actuals')
    overview_data = request_pcs_data(bid_id, '')

    unless actuals_data.nil? || overview_data.nil?
      HomesEngland::Domain::PcsBid.new.tap do |project|
        project.project_manager = overview_data[:ProjectManager]
        project.sponsor = overview_data[:Sponsor]
        project.actuals = actuals_data
      end
    end
  end

  def request_pcs_data(bid_id, endpoint)
    pcs_key = JWT.encode({}, ENV['PCS_SECRET'], 'HS512')
    host = URI.parse(@pcs_domain).host
    protocol = URI.parse(@pcs_domain).scheme

    if protocol == 'http'
      port = Net::HTTP.http_default_port()
      pcs_endpoint = Net::HTTP.new(host, port)
    else
      port = Net::HTTP.https_default_port()
      pcs_endpoint = Net::HTTP.new(host, port)
      pcs_endpoint.use_ssl = true
    end

    request = Net::HTTP::Get.new("/pcs-api/v1/Projects/#{encode_bid_id(bid_id)}#{endpoint}")
    request['Authorization'] = "Bearer #{pcs_key}"
    response = pcs_endpoint.request(request)
    if response.kind_of?(Net::HTTPSuccess)
      Common::DeepSymbolizeKeys.to_symbolized_hash(JSON.parse(response.body))
    end
  end

  def encode_bid_id(bid_id)
    ERB::Util.url_encode(ERB::Util.url_encode(bid_id))
  end
end
