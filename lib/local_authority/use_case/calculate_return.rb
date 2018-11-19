class LocalAuthority::UseCase::CalculateReturn
  def initialize(calculate_hif_return:, calculate_ac_return:)
    @calculate_hif_return = calculate_hif_return
    @calculate_ac_return = calculate_ac_return
  end

  def execute(return_with_no_calculations: , previous_return:)
    if return_with_no_calculations[:type] == 'hif'
      @calculate_hif_return.execute(return_data_with_no_calculations: return_with_no_calculations.dig(:updates, -1), previous_return: previous_return&.dig(:updates, -1))
    else
      @calculate_ac_return.execute(return_data_with_no_calculations: return_with_no_calculations.dig(:updates, -1), previous_return: previous_return&.dig(:updates, -1))
    end
  end
end
