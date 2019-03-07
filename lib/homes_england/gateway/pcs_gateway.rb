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
    pcs_domain_uri = URI(@pcs_domain)
    use_ssl = pcs_domain_uri.scheme == 'https'
    Net::HTTP.start(pcs_domain_uri.host, pcs_domain_uri.port, use_ssl: use_ssl) do |http|
      request = Net::HTTP::Get.new("/pcs-api/v1/Projects/#{encode_bid_id(bid_id)}#{endpoint}")
      request['Authorization'] = "Bearer #{generate_pcs_key()}"
      response = http.request(request)
      if response.kind_of?(Net::HTTPSuccess)
        Common::DeepSymbolizeKeys.to_symbolized_hash(JSON.parse(response.body))
      end
    end
  end

  def encode_bid_id(bid_id)
    ERB::Util.url_encode(ERB::Util.url_encode(bid_id))
  end

  def generate_pcs_key()
    thirty_days_in_seconds = 60 * 60 * 24 * 30
    thirty_days_from_now = Time.now.to_i + thirty_days_in_seconds
    JWT.encode(
      {
        exp: thirty_days_from_now
      },
      ENV['PCS_SECRET'],
      'HS512'
    )
  end
end
