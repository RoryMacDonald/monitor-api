class UI::UseCase::ConvertUIClaim
  def initialize(convert_ui_ac_claim:, convert_ui_hif_claim:, convert_ui_ff_claim:)
    @convert_ui_hif_claim = convert_ui_hif_claim
    @convert_ui_ac_claim = convert_ui_ac_claim
    @convert_ui_ff_claim = convert_ui_ff_claim
  end

  def execute(claim_data:, type:)
    return @convert_ui_hif_claim.execute(claim_data: claim_data) if type == 'hif'
    return @convert_ui_ff_claim.execute(claim_data: claim_data) if type == 'ff'
    @convert_ui_ac_claim.execute(claim_data: claim_data)
  end
end
