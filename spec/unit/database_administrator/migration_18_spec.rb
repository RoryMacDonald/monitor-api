# frozen_string_literal: true

describe 'Migration 18' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 17)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 18)
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

  let(:migrated_version) do
    database[:projects]
      .all
      .first[:version]
  end

  it 'Creates a version column' do
    expect(migrated_version).to eq(1)
  end
end
