class UI::UseCase::ConvertCoreClaim
  def initialize(convert_core_ac_claim:, convert_core_hif_claim:, convert_core_ff_claim:)
    @convert_core_hif_claim = convert_core_hif_claim
    @convert_core_ac_claim = convert_core_ac_claim
    @convert_core_ff_claim = convert_core_ff_claim
  end

  def execute(claim_data:, type:)
    return @convert_core_hif_claim.execute(claim_data: claim_data) if type == 'hif'
    return @convert_core_ff_claim.execute(claim_data: claim_data) if type == 'ff'
    @convert_core_ac_claim.execute(claim_data: claim_data)
  end
end
