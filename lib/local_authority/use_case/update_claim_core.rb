class LocalAuthority::UseCase::UpdateClaimCore
  def initialize(claim_gateway:)
    @claim_gateway = claim_gateway
  end

  def execute(claim_id:,claim_data:)
    claim = LocalAuthority::Domain::Claim.new.tap do |claim|
      claim.data = claim_data
    end
    @claim_gateway.update(claim_id: claim_id, claim: claim)
  end
end
