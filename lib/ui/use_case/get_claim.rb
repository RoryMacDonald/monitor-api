class UI::UseCase::GetClaim
  def initialize(get_claim_core:, claim_schema:, convert_core_claim:)
    @get_claim_core = get_claim_core
    @claim_schema = claim_schema
    @convert_core_claim = convert_core_claim
  end

  def execute(claim_id:)
    found_claim = @get_claim_core.execute(claim_id: claim_id)
    template =  @claim_schema.find_by(type: found_claim[:type])
    converted_data = @convert_core_claim.execute(
      claim_data: found_claim[:data],
      type: found_claim[:type]
    )

    {
      id: found_claim[:id],
      project_id: found_claim[:project_id],
      status: found_claim[:status],
      type: found_claim[:type],
      bid_id: found_claim[:bid_id],
      schema: template.schema,
      data: converted_data
    }
  end
end
