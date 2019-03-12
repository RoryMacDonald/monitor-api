class HomesEngland::Gateway::SequelBaseline
  def initialize(database:)
    @database = database
  end

  def create(baseline)
    @database[:baselines].insert(
      project_id: baseline.project_id,
      data: Sequel.pg_json(baseline.data),
      status: 'Draft',
      version: baseline.version,
      timestamp: baseline.timestamp
    )
  end

  def find_by(id:)
    row = @database[:baselines].where(id: id).first
    row_to_baseline(row)
  end

  def update(id:, baseline:)
    @database[:baselines].where(id: id).update(
      data: Sequel.pg_json(baseline.data),
      timestamp: baseline.timestamp
    )
  end

  def submit(id:)
    @database[:baselines].where(id: id).update(
      status: 'Submitted'
    )
  end

  def versions_for(project_id:)
    @database[:baselines].where(project_id: project_id).order(:version).map { |row| row_to_baseline(row) }
  end

  private 

  def row_to_baseline(row)
    HomesEngland::Domain::Baseline.new.tap do |baseline|
      baseline.id = row[:id]
      baseline.project_id = row[:project_id]
      baseline.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      baseline.version = row[:version]
      baseline.status = row[:status]
      baseline.timestamp = row[:timestamp]
    end
  end
end
