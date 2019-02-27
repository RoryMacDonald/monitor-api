class LocalAuthority::UseCase::SubmitClaimCore
  def initialize(claim_gateway:)
    @claim_gateway = claim_gateway
  end

  def execute(claim_id:)
    @claim_gateway.submit(claim_id: claim_id)
  end
end
