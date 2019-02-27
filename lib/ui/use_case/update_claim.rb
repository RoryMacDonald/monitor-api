class UI::UseCase::UpdateClaim
  def initialize(get_claim:, update_claim_core:, convert_ui_claim:)
    @get_claim = get_claim
    @convert_ui_claim = convert_ui_claim
    @update_claim_core = update_claim_core
  end

  def execute(claim_id:, claim_data:)
    type = @get_claim.execute(claim_id: claim_id)[:type]
    converted_data = @convert_ui_claim.execute(claim_data: claim_data, type: type)
    @update_claim_core.execute(claim_id: claim_id, claim_data: converted_data)
  end
end
