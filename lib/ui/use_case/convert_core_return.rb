class UI::UseCase::ConvertCoreReturn
  def initialize(convert_core_hif_return:, convert_core_ac_return:, convert_core_ff_return:, sanitise_data:)
    @convert_core_hif_return = convert_core_hif_return
    @convert_core_ac_return = convert_core_ac_return
    @convert_core_ff_return = convert_core_ff_return
    @sanitise_data = sanitise_data
  end

  def execute(return_data:, type:)
    return_data = @convert_core_hif_return.execute(return_data: return_data) if type == 'hif'
    return_data = @convert_core_ac_return.execute(return_data: return_data) if type == 'ac'
    return_data = @convert_core_ff_return.execute(return_data: return_data) if type == 'ff'

    @sanitise_data.execute(data: return_data)
  end
end
