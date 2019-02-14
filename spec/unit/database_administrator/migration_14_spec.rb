# frozen_string_literal: true

describe 'Migration 14' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 13)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 14)
  end

  def create_return(type:, data:)
    project_id = database[:projects].insert(name: 'A project name', type: 'hif', data: Sequel.pg_json({}))
    return_id = database[:returns].insert(project_id: project_id, status: 'Submitted')
    database[:return_updates].insert(
      return_id: return_id,
      data: Sequel.pg_json(return_data)
    )
  end

  let(:migrator) { ::Migrator.new }

  before do
    synchronize_to_non_migrated_version

    create_return(type: 'hif', data: return_data)
    synchronize_to_migrated_version
  end

  let(:unmigrated_infrastructure_deliveries) do
    database[:return_updates]
      .all
      .first[:data]['reviewAndAssurance']['infrastructureDelivery']
  end

  let(:migrated_infrastructure_deliveries) do
    database[:return_updates]
      .all
      .first[:data]['reviewAndAssurance']['infrastructureDeliveries']
  end
  context 'With data' do
    context 'Example one' do
      let(:return_data) do
        {
          reviewAndAssurance: {
            infrastructureDelivery: {
              someData: 'value'
            }
          }
        }
      end

      it 'Rename infrastructure deliveries' do
        expect(migrated_infrastructure_deliveries).to eq({'someData' => 'value'})
        expect(unmigrated_infrastructure_deliveries).to eq(nil)
      end
    end

    context 'Example two' do
      let(:return_data) do
        {
          reviewAndAssurance: {
            infrastructureDelivery: {
              otherData: "Another value"
            }
          }
        }
      end

      it 'Rename infrastructure deliveries' do
        expect(migrated_infrastructure_deliveries).to eq({'otherData' => 'Another value'})
        expect(unmigrated_infrastructure_deliveries).to eq(nil)
      end
    end
  end

  context 'without data' do
    context 'Example one' do
      let(:return_data) do
        {
          reviewAndAssurance: {
          }
        }
      end

      it 'Does nothing' do
        expect(
          database[:return_updates]
              .all
              .first[:data]['reviewAndAssurance']
        ).to eq({})
      end
    end

    context 'Example two' do
      let(:return_data) do
        {
        }
      end

      it 'Does nothing' do
        expect(
          database[:return_updates]
              .all
              .first[:data]
        ).to eq({})
      end
    end
  end
end
