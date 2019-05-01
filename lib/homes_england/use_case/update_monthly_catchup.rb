class HomesEngland::UseCase::UpdateMonthlyCatchup

  def initialize(monthly_catchup_gateway:)
    @monthly_catchup_gateway = monthly_catchup_gateway
  end

  def execute(monthly_catchup_id:, monthly_catchup_data:)
    monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
      monthly_catchup.id = monthly_catchup_id
      monthly_catchup.data = monthly_catchup_data
    end

    @monthly_catchup_gateway.update(monthly_catchup)
  end
end
