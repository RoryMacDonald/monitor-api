# frozen_string_literal: true

describe 'Migration 20' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 19)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 20)
  end

  def create_project(type:, data:, status:, timestamp:)
    database[:projects].insert(
      type: type,
      timestamp: timestamp,
      data: Sequel.pg_json(data),
      status: status
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
        }
      }
    end

    let(:migrated_baseline_data) { database[:baselines].all.first }
    let(:migrated_project_data) { database[:projects].all.first }

    before do
      project_id = create_project(
        type: 'hif',
        data: baseline_data,
        status: 'Draft',
        timestamp: 123455
      )
      synchronize_to_migrated_version
    end

    it 'Migrates the data to the baselines table' do
      stored_baseline_data = Common::DeepSymbolizeKeys.to_symbolized_hash(migrated_baseline_data[:data].to_h)

      expect(stored_baseline_data).to eq(baseline_data)
    end

    it 'Migrates the status to the baselines table' do
      baseline_status = migrated_baseline_data[:status]

      expect(baseline_status).to eq('Draft')
    end

    it 'Migrates the timestamp to the baselines table' do
      baseline_timestamp = migrated_baseline_data[:timestamp]

      expect(baseline_timestamp).to eq(123455)
    end

    it 'Removes the baseline data and version from the project table' do
      project_data = migrated_project_data[:data]

      expect(project_data).to be_nil
    end
  end

  context 'Example 2' do 
    let(:baseline_data) do
      {
        planning: {
          outlinePlanning: {
            baselineOutlinePlanningPermissionGranted: "No",
            reference: "Ref101",
            baselineSummaryOfCriticalPath: "Summary of critical path",
            planningSubmitted: {
              baseline: "2020-01-01"
            },
            planningGranted: {
              baseline: "2020-02-01"
            }
          }
        }
      }
    end
  
    let(:migrated_baseline_data) { database[:baselines].all.first }
    let(:migrated_project_data) { database[:projects].all.first }
  
    before do
      project_id = create_project(
        type: 'hif',
        data: baseline_data,
        status: 'Submitted',
        timestamp: 34567
      )
      synchronize_to_migrated_version
    end
  
    it 'Migrates the data to the baselines table' do
      stored_baseline_data = Common::DeepSymbolizeKeys.to_symbolized_hash(migrated_baseline_data[:data].to_h)
  
      expect(stored_baseline_data).to eq(baseline_data)
    end
  
    it 'Migrates the status to the baselines table' do
      baseline_status = migrated_baseline_data[:status]
  
      expect(baseline_status).to eq('Submitted')
    end

    it 'Migrates the timestamp to the baselines table' do
      baseline_timestamp = migrated_baseline_data[:timestamp]

      expect(baseline_timestamp).to eq(34567)
    end
  
    it 'Removes the baseline data and version from the project table' do
      project_data = migrated_project_data[:data]
  
      expect(project_data).to be_nil
    end
  end
end
