class UI::UseCase::ConvertUIReturn
  def initialize(convert_ui_hif_return:, convert_ui_ac_return:, convert_ui_ff_return:)
    @convert_ui_hif_return = convert_ui_hif_return
    @convert_ui_ac_return = convert_ui_ac_return
    @convert_ui_ff_return = convert_ui_ff_return
  end

  def execute(return_data:, type:)
    return @convert_ui_hif_return.execute(return_data: return_data) if type == 'hif'
    return @convert_ui_ac_return.execute(return_data: return_data) if type == 'ac'
    return @convert_ui_ff_return.execute(return_data: return_data) if type == 'ff'

    return_data
  end
end
