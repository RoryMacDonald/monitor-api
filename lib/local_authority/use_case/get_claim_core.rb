class LocalAuthority::UseCase::GetClaimCore
  def initialize(claim_gateway:)
    @claim_gateway = claim_gateway
  end

  def execute(claim_id:)
    found_claim = @claim_gateway.find_by(claim_id: claim_id)

    {
      id: found_claim.id,
      project_id: found_claim.project_id,
      bid_id: found_claim.bid_id,
      status: found_claim.status,
      type: found_claim.type,
      data: found_claim.data
    }
  end
end
