class UI::UseCase::ConvertUIReturn
  def initialize(convert_ui_hif_return:, convert_ui_ac_return:, convert_ui_ff_return:)
    @convert_ui_hif_return = convert_ui_hif_return
    @convert_ui_ac_return = convert_ui_ac_return
    @convert_ui_ff_return = convert_ui_ff_return
  end

  def execute(return_data:, type:)
    return_data = @convert_ui_hif_return.execute(return_data: return_data) if type == 'hif'
    return_data = @convert_ui_ac_return.execute(return_data: return_data) if type == 'ac'
    return_data = @convert_ui_ff_return.execute(return_data: return_data) if type == 'ff'

    compact(return_data)
  end

  private

  def compact(data)  
    if complex_object?(data)
      data.compact!
      data.each do |value|
        compact(value)
      end
    end
  end

  def complex_object?(obj)
    (obj.class == Hash || obj.class == Array)
  end
end
