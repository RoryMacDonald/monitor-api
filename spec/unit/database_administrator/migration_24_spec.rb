# frozen_string_literal: true

describe 'Migration 24' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 23)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 24)
  end

  def create_project(name:, type:, status:)
    database[:projects].insert(
      name: name,
      type: type,
      status: status
    )
  end

  def create_baseline(project_id:, data:, status:, version:)
    database[:baselines].insert(
      project_id: project_id,
      data: data,
      status: status,
      version: version
    )
  end

  let(:migrator) { ::Migrator.new }

  before { synchronize_to_non_migrated_version }

  context 'Example 1' do
    let(:baseline_data) do
      {
        summary: { noOfHousingSites: 15, totalArea: 12, hifFundingAmount: 10_000 },
        infrastructures: [
          {
            landOwnership: {
              howManySitesToAcquire: 10
            }
          }
        ],
        outputsForecast: {
          totalUnits: 5
        },
        rmBaseline: {
          details: 'names',
          address: 'my address',
          phone: '0121012'
        }
      }
    end

    let(:migrated_baseline_data) { database[:baselines].all.first }
    let(:migrated_project_data) { database[:projects].all.first }

    before do
      project_id = create_project(
        type: 'hif',
        status: 'Submitted',
        name: 'My HIF project'
      )

      baseline_id = create_baseline(
        project_id: project_id,
        data: Sequel.pg_json(baseline_data),
        status: 'Submitted',
        version: 1
      )

      synchronize_to_migrated_version
    end

    it 'Migrates the rm baseline data to the project table' do
      stored_project_data = Common::DeepSymbolizeKeys.to_symbolized_hash(migrated_project_data[:data].to_h)

      expect(stored_project_data).to eq({
        details: 'names',
        address: 'my address',
        phone: '0121012'
      })
    end

    it 'Add a timestamp to the project' do
      expect(migrated_project_data[:timestamp]).to eq(0)
    end
  end
end