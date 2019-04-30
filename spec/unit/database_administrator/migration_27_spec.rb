describe 'Migration 27' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 26)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 27)
  end

  let(:migrator) { Migrator.new }

  before do
    synchronize_to_non_migrated_version
    synchronize_to_migrated_version
  end

  it 'creates the reviews tab' do
    expect(
      database[:reviews].insert(data: Sequel.pg_json({}), project_id: 1, status: 'Draft')
    )
  end
end
