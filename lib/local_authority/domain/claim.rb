class LocalAuthority::Domain::Claim
  attr_accessor :id, :project_id, :type, :status, :data, :bid_id
  def initialize
    @status = 'Draft'
  end
end
