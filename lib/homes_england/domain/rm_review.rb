class HomesEngland::Domain::RmReview
  attr_accessor :id, :project_id, :data, :status

  def initialize()
    @status = 'Draft'
  end
end
