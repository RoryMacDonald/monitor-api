class LocalAuthority::Gateway::SequelReturn
  def initialize(database:)
    @database = database
  end

  def create(new_return)
    @database[:returns].insert(
      project_id: new_return.project_id,
      status: new_return.status
    )
  end

  def find_by(id:)
    row = @database[:returns]
    .select_append(Sequel[:returns][:id].as(:return_id))
    .select_append(Sequel[:returns][:status].as(:return_status))
      .where(Sequel.qualify(:returns, :id) => id)
      .join(:projects, id: :project_id)
      .first

    LocalAuthority::Domain::Return.new.tap do |r|
      r.id = row[:return_id]
      r.bid_id = row[:bid_id]
      r.type = row[:type]
      r.project_id = row[:project_id]
      r.status = row[:return_status]
      r.timestamp = row[:timestamp]
    end
  end

  def get_returns(project_id:)
    @database[:returns].where(project_id: project_id).order(:id).all.map do |db_r|
      LocalAuthority::Domain::Return.new.tap do |r|
        r.id = db_r[:id]
        r.project_id = db_r[:project_id]
        r.status = db_r[:status]
        r.timestamp = db_r[:timestamp]
      end
    end
  end

  def delete(return_id:)
    @database[:returns].where(id: return_id).delete
  end

  def submit(return_id:, timestamp:)
    @database[:returns].where(id: return_id).update(status: 'Submitted')
    @database[:returns].where(id: return_id).update(timestamp: timestamp)
  end
end
