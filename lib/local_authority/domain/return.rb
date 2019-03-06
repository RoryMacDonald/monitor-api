class LocalAuthority::Domain::Return
  attr_accessor :id, :project_id, :type, :status, :updates, :timestamp, :bid_id, :baseline_version
  def initialize
    @status = 'Draft'
  end
end
