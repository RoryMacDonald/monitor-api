# frozen_string_literal: true

class HomesEngland::Gateway::SequelProject
  def initialize(database:)
    @database = database
  end

  def create(project)
    @database[:projects].insert(
      name: project.name,
      type: project.type,
      data: Sequel.pg_json(project.data),
      status: project.status,
      bid_id: project.bid_id,
      version: 1
    )
  end

  def find_by(id:)
    row = @database[:projects].where(id: id).first

    HomesEngland::Domain::Project.new.tap do |p|
      p.name = row[:name]
      p.type = row[:type]
      p.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      p.status = row[:status]
      p.timestamp = row[:timestamp]
      p.bid_id = row[:bid_id]
      p.version = row[:version]
    end
  end

  def update(id:, project:)
    updated = @database[:projects]
              .where(id: id)
              .update(
                name: project.name,
                data: Sequel.pg_json(project.data),
                status: project.status,
                timestamp: project.timestamp,
                bid_id: project.bid_id
              )

    { success: updated.positive? }
  end

  def submit(id:, status:)
    @database[:projects].where(id: id).update(status: status)
  end

  def all()
    @database[:projects].all.map do |row|
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = row[:id]
        p.name = row[:name]
        p.type = row[:type]
        p.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
        p.status = row[:status]
        p.timestamp = row[:timestamp]
        p.bid_id = row[:bid_id]
        p.version = row[:version]
      end
    end
  end
end
