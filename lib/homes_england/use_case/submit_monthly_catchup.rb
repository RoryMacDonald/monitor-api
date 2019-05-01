class HomesEngland::UseCase::SubmitMonthlyCatchup

  def initialize(monthly_catchup_gateway:)
    @monthly_catchup_gateway = monthly_catchup_gateway
  end

  def execute(monthly_catchup_id:)
    @monthly_catchup_gateway.submit(id: monthly_catchup_id)
  end
end
