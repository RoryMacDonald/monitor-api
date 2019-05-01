class UI::UseCase::ConvertCoreMonthlyCatchup

  def initialize(convert_core_hif_monthly_catchup:)
    @convert_core_hif_monthly_catchup = convert_core_hif_monthly_catchup
  end

  def execute(type:, monthly_catchup_data:)
    return @convert_core_hif_monthly_catchup.execute(monthly_catchup_data: monthly_catchup_data) if type == 'hif'
    nil
  end
end
