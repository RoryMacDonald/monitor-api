class HomesEngland::Domain::RmMonthlyCatchup
  attr_accessor :id, :project_id, :data, :status

  def initialize()
    @status = 'Draft'
  end
end
