class LocalAuthority::Gateway::SequelClaim
  def initialize(database:)
    @database = database
  end

  def create(claim)
    @database[:claims].insert(
      project_id: claim.project_id,
      status: claim.status,
      data: Sequel.pg_json(claim.data)
    )
  end

  def update(claim_id:, claim:)
    @database[:claims].where(id: claim_id).update(data: Sequel.pg_json(claim.data))
  end

  def find_by(claim_id:)
    row = @database[:claims]
      .select_append(Sequel[:claims][:id].as(:claim_id))
      .select_append(Sequel[:claims][:data].as(:claims_data))
      .select_append(Sequel[:claims][:status].as(:claims_status))
      .where(Sequel.qualify(:claims, :id) => claim_id)
      .join(:projects, id: :project_id)
      .first

    LocalAuthority::Domain::Claim.new.tap do |claim|
      claim.id = row[:claim_id]
      claim.project_id = row[:project_id]
      claim.type = row[:type]
      claim.bid_id = row[:bid_id]
      claim.status = row[:claims_status]
      claim.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:claims_data].to_h)
    end
  end

  def get_all(project_id:)
    @database[:claims].where(project_id: project_id).order(:id).all.map do |row|
      LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.id = row[:id]
        claim.project_id = row[:project_id]
        claim.status = row[:status]
        claim.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      end
    end
  end

  def submit(claim_id:)
    @database[:claims].update(status: 'Submitted')
  end
end
