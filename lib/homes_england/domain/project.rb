class HomesEngland::Domain::Project
  attr_accessor :id, :bid_id, :name, :type, :data, :status, :timestamp, :version

  def initialize
    @status = 'Draft'
  end
end
