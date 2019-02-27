class LocalAuthority::UseCase::CreateClaimCore
  def initialize(claim_gateway:)
    @claim_gateway = claim_gateway
  end

  def execute(project_id:, claim_data:)
    claim = LocalAuthority::Domain::Claim.new.tap do |claim|
      claim.project_id = project_id
      claim.data = claim_data
    end
    claim_id = @claim_gateway.create(claim)

    { claim_id: claim_id }
  end
end
