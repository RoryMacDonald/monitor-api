class UI::UseCase::ConvertCoreReturn
  def initialize(convert_core_hif_return:, convert_core_ac_return:, convert_core_ff_return:)
    @convert_core_hif_return = convert_core_hif_return
    @convert_core_ac_return = convert_core_ac_return
    @convert_core_ff_return = convert_core_ff_return
  end

  def execute(return_data:, type:)
    return @convert_core_hif_return.execute(return_data: return_data) if type == 'hif'
    return @convert_core_ac_return.execute(return_data: return_data) if type == 'ac'
    return @convert_core_ff_return.execute(return_data: return_data) if type == 'ff'

    return_data
  end
end
