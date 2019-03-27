# frozen_string_literal: true

class HomesEngland::Gateway::SequelProject
  def initialize(database:)
    @database = database
  end

  def create(project)
    @database[:projects].insert(
      name: project.name,
      type: project.type,
      status: project.status,
      bid_id: project.bid_id
    )
  end

  def find_by(id:)
    row = @database[:projects].where(id: id).first

    HomesEngland::Domain::Project.new.tap do |p|
      p.name = row[:name]
      p.type = row[:type]
      p.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      p.status = row[:status]
      p.bid_id = row[:bid_id]
      p.timestamp = row[:timestamp]
    end
  end

  def update(id:, data:, timestamp:)
    @database[:projects].where(id: id).update(
      data: Sequel.pg_json(data),
      timestamp: timestamp
    )
  end

  def all()
    @database[:projects].all.map do |row|
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = row[:id]
        p.name = row[:name]
        p.type = row[:type]
        p.status = row[:status]
        p.bid_id = row[:bid_id]
      end
    end
  end

  def submit(id:, status:)
    @database[:projects].where(id: id).update(status: status)
  end
end
