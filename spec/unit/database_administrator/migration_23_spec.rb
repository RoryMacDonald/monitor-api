# frozen_string_literal: true

describe 'Migration 23' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 22)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 23)
  end

  let(:project_id) { database[:projects].insert(status: 'Draft', type: 'hif') }

  def create_baseline(project_id, data)
    database[:baselines].insert(project_id: project_id, data: Sequel.pg_json(data))
  end

  let(:migrator) { ::Migrator.new }

  let(:migrated_baseline_data) do
    Common::DeepSymbolizeKeys.to_symbolized_hash(database[:baselines]
      .all
      .first[:data].to_h)
  end

  before do 
    synchronize_to_non_migrated_version
    create_baseline(project_id, data)
    synchronize_to_migrated_version
  end

  context 'moving joint bid areas into an array' do
    let(:data) do
      {
        summary: {
          jointBidAreas: 'made tech'
        }
      }
    end

    it 'migrates successfully' do
      expect(migrated_baseline_data).to eq({
        summary: {
          jointBidAreas: 'made tech',
          jointBidAuthorityAreas: ['made tech']
        }
      })
    end
  end
end
