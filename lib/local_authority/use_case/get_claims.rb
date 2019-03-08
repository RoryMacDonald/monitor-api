
class LocalAuthority::UseCase::GetClaims
  def initialize(claims_gateway:)
    @claims_gateway = claims_gateway
  end

  def execute(project_id:)
    claims = @claims_gateway.get_all(project_id: project_id)
    claims = claims.map do |claim|
      {
        id: claim.id,
        project_id: claim.project_id,
        type: claim.type,
        status: claim.status,
        data: claim.data,
        bid_id: claim.bid_id
      }
    end

    { claims: claims }
  end
end