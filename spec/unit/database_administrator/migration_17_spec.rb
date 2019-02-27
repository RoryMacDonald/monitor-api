# frozen_string_literal: true

describe 'Migration 17' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 16)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 17)
  end

  def create_claim(project_id, type, status, data)
    database[:claims].insert(
      project_id: project_id,
      type: type,
      status: status,
      data: Sequel.pg_json(data)
    )
  end

  let(:migrator) { ::Migrator.new }

  before do
    synchronize_to_non_migrated_version
    synchronize_to_migrated_version
  end

  it 'can add a claim with relevant details' do
    create_claim(1, 'hif', 'Draft', {claim_summary: "Summary"})
    expect(database[:claims].all.first[:project_id]).to eq(1)
    expect(database[:claims].all.first[:type]).to eq('hif')
    expect(database[:claims].all.first[:status]).to eq('Draft')
    expect(database[:claims].all.first[:data].to_h).to eq({"claim_summary" => "Summary"})
  end
end
