class LocalAuthority::UseCase::PcsPopulateClaim
  def initialize(get_claim_core:, pcs_gateway:)
    @get_claim_core = get_claim_core
    @pcs_gateway = pcs_gateway
  end

  def execute(claim_id:)
    found_claim = @get_claim_core.execute(claim_id: claim_id)
    unless ENV['PCS'].nil?
      @pcs_gateway.get_project(bid_id: found_claim[:bid_id])
    end

    found_claim
  end
end
