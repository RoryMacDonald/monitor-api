# frozen_string_literal: true

describe 'Migration 20' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 18)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 19)
  end

  def create_baseline(project_id, status, data, timestamp)
    database[:baselines].insert(
      project_id: project_id,
      status: status,
      timestamp: timestamp,
      data: Sequel.pg_json(data)
    )
  end

  let(:migrator) { ::Migrator.new }

  before do
    synchronize_to_non_migrated_version
    synchronize_to_migrated_version
  end

  it 'can add a baseline with relevant details' do
    create_baseline(1, 'Draft', {baseline_data: "Summary"}, 12345)
    expect(database[:baselines].all.first[:project_id]).to eq(1)
    expect(database[:baselines].all.first[:version]).to eq(1)
    expect(database[:baselines].all.first[:timestamp]).to eq(12345)
    expect(database[:baselines].all.first[:status]).to eq('Draft')
    expect(database[:baselines].all.first[:data].to_h).to eq({"baseline_data" => "Summary"})
  end
end
