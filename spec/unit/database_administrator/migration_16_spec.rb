# frozen_string_literal: true

describe 'Migration 16' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 15)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 16)
  end

  def create_project(type:, bid_reference: nil)
    if bid_reference.nil?
      json_data = {}
    else
      json_data = {
        summary: {
          BIDReference: bid_reference
        }
      }
    end

    database[:projects].insert(
      name: 'A project name',
      type: type,
      data: Sequel.pg_json(json_data)
    )
  end

  let(:migrator) { ::Migrator.new }

  let(:migrated_bid_id) do
    database[:projects]
      .all
      .first[:bid_id]
  end

  context 'hif project' do
    context 'Copies BIDReference to the bid_id column' do
      it 'example 1' do
        synchronize_to_non_migrated_version
        create_project(type: 'hif', bid_reference: 'HIF/MV/1')
        synchronize_to_migrated_version

        expect(migrated_bid_id).to eq('HIF/MV/1')
      end

      it 'example 2' do
        synchronize_to_non_migrated_version
        create_project(type: 'hif', bid_reference: 'HIF/MV/3')
        synchronize_to_migrated_version

        expect(migrated_bid_id).to eq('HIF/MV/3')
      end
    end
  end

  context 'ac project' do
    it 'Copies BIDReference to the bid_id column' do
      synchronize_to_non_migrated_version
      create_project(type: 'ac')
      synchronize_to_migrated_version

      expect(migrated_bid_id).to eq(nil)
    end
  end
end
