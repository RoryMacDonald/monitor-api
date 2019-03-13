# frozen_string_literal: true

describe 'Migration 18' do
  include_context 'with database'

   def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 18)
  end

   def synchronize_to_migrated_version
    migrator.migrate_to(database, 19)
  end

   def create_return()
    return_id = database[:returns].insert(project_id: 1, status: 'Draft')
  end

   let(:migrator) { ::Migrator.new }

   before do
    synchronize_to_non_migrated_version
    create_return
    synchronize_to_migrated_version
  end

   let(:migrated_baseline_version) do
    database[:returns]
      .all
      .first[:baseline_version]
  end

   it 'Creates a version column' do
    expect(migrated_baseline_version).to eq(1)
  end
end