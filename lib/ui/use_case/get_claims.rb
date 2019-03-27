class UI::UseCase::GetClaims
  def initialize(get_claims:, find_project:, convert_core_claim:)
    @get_claims = get_claims
    @find_project = find_project
    @convert_core_claim = convert_core_claim
  end

  def execute(project_id:)
    found_claims = @get_claims.execute(project_id: project_id)[:claims]
    type = @find_project.execute(id: project_id)[:type]

    found_claims = found_claims.map do |found_claim|
      found_claim[:data] = @convert_core_claim.execute(claim_data: found_claim[:data], type: type)
      found_claim
    end

    { claims: found_claims }
  end
end
