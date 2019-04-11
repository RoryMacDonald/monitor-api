# frozen_string_literal: true

describe 'Migration 24' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 23)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 24)
  end

  let(:return_id) { nil }

  def create_return_update(data)
    database[:return_updates].insert(return_id: return_id, data: Sequel.pg_json(data))
  end

  let(:migrator) { ::Migrator.new }

  def get_return_update(index)
    Common::DeepSymbolizeKeys.to_symbolized_hash(database[:return_updates]
      .all[index][:data].to_h)
  end

  context 'moving outputsActuals into an array' do
    before do
      synchronize_to_non_migrated_version
      create_return_update(data)
      create_return_update(second_data)
      synchronize_to_migrated_version
    end

    let(:data) do
      {
        outputsActuals: {
          localAuthority: "A local authority",
          noOfUnits: "10"
        }
      }
    end

    let(:second_data) do
      {
        outputsActuals: {
          size: "65"
        }
      }
    end

    it 'migrates successfully' do
      expect(get_return_update(0)).to eq({
        outputsActuals: [{
          localAuthority: "A local authority",
          noOfUnits: "10"
        }]
      })

      expect(get_return_update(1)).to eq({
        outputsActuals: [{size: "65"}]
      })
    end
  end
end
