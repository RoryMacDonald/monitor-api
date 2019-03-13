class HomesEngland::UseCase::SubmitBaseline
  def initialize(baseline_gateway:)
    @baseline_gateway = baseline_gateway
  end

  def execute(id:)
    @baseline_gateway.submit(id: id)
  end
end