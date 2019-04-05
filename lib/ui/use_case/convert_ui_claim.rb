class UI::UseCase::ConvertUIClaim
  def initialize(convert_ui_ac_claim:, convert_ui_hif_claim:, convert_ui_ff_claim:, sanitise_data:)
    @convert_ui_hif_claim = convert_ui_hif_claim
    @convert_ui_ac_claim = convert_ui_ac_claim
    @convert_ui_ff_claim = convert_ui_ff_claim
    @sanitise_data = sanitise_data
  end

  def execute(claim_data:, type:)
    claim_data = @convert_ui_hif_claim.execute(claim_data: claim_data) if type == 'hif'
    claim_data =  @convert_ui_ff_claim.execute(claim_data: claim_data) if type == 'ff'
    claim_data = @convert_ui_ac_claim.execute(claim_data: claim_data) if type == 'ac'

    @sanitise_data.execute(data: claim_data)
  end
end
