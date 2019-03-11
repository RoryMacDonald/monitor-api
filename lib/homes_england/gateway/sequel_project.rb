# frozen_string_literal: true

class HomesEngland::Gateway::SequelProject
  def initialize(database:)
    @database = database
  end

  def create(project)
    @database[:projects].insert(
      name: project.name,
      type: project.type,
      bid_id: project.bid_id,
    )
  end

  def find_by(id:)
    row = @database[:projects].where(id: id).first

    HomesEngland::Domain::Project.new.tap do |p|
      p.name = row[:name]
      p.type = row[:type]
      p.bid_id = row[:bid_id]
    end
  end

  def all()
    @database[:projects].all.map do |row|
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = row[:id]
        p.name = row[:name]
        p.type = row[:type]
        p.bid_id = row[:bid_id]
      end
    end
  end
end
