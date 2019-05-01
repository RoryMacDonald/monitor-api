class HomesEngland::UseCase::GetRmMonthlyCatchup

  def initialize(monthly_catchup_gateway:)
    @monthly_catchup_gateway = monthly_catchup_gateway
  end

  def execute(monthly_catchup_id:)
    @monthly_catchup_gateway.find_by(id: monthly_catchup_id).then do |monthly_catchup|
      {
        id: monthly_catchup.id,
        project_id: monthly_catchup.project_id,
        data: monthly_catchup.data,
        status: monthly_catchup.status
      }
    end
  end
end
