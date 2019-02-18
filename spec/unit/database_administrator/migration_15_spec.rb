# frozen_string_literal: true

describe 'Migration 15' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 14)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 15)
  end

  def create_project()
    project_id = database[:projects].insert(name: 'A project name', type: 'hif', data: Sequel.pg_json({}))
  end

  let(:migrator) { ::Migrator.new }

  before do
    synchronize_to_non_migrated_version
    create_project
    synchronize_to_migrated_version
  end

  let(:migrated_bid_id) do
    database[:projects]
      .all
      .first[:bid_id]
  end

  it 'Creates a bid_id column' do
    expect(migrated_bid_id).to eq(nil)
  end
end
