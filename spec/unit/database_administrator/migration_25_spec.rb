# frozen_string_literal: true

describe 'Migration 25' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 24)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 25)
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

  context 'makes a nil outputsActuals an array' do
    before do
      synchronize_to_non_migrated_version
      create_return_update(data)
      synchronize_to_migrated_version
    end

    let(:data) do
      {
        outputsActuals: nil
      }
    end

    it 'migrates successfully' do
      expect(get_return_update(0)).to eq({
        outputsActuals: []
      })
    end
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
        outputsActuals: [nil]
      }
    end

    let(:second_data) do
      {
        outputsActuals: [{cat: 'meow'}, nil]
      }
    end

    it 'migrates successfully' do
      expect(get_return_update(0)).to eq({
        outputsActuals: []
      })

      expect(get_return_update(1)).to eq({
        outputsActuals: [{cat: 'meow'}]
      })
    end
  end

  context 'does not affect existing correct outputsActuals' do
    before do
      synchronize_to_non_migrated_version
      create_return_update(data)
      create_return_update(second_data)
      synchronize_to_migrated_version
    end

    let(:data) do
      {
        outputsActuals: [{
          size: "1415"
        }]
      }
    end

    let(:second_data) do
      {
        outputsActuals: [{
          localAuthority: "My local authority",
          noOfUnits: "255"
        }]
      }
    end

    it 'migrates successfully' do
      expect(get_return_update(0)).to eq({
        outputsActuals: [{size: "1415"}]
      })

      expect(get_return_update(1)).to eq({
        outputsActuals: [{
          localAuthority: "My local authority",
          noOfUnits: "255"
        }]
      })

    end
  end
end
