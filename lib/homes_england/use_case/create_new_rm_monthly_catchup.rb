class HomesEngland::UseCase::CreateNewRmMonthlyCatchup
  def initialize(monthly_catchup_gateway:)
    @monthly_catchup_gateway = monthly_catchup_gateway
  end

  def execute(project_id:, monthly_catchup_data:)
    monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
      monthly_catchup.project_id = project_id
      monthly_catchup.data = monthly_catchup_data
    end

    monthly_catchup_id = @monthly_catchup_gateway.create(monthly_catchup)

    { id: monthly_catchup_id }
  end
end
