# frozen_string_literal: true

describe 'Migration 21' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 20)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 21)
  end

  def create_project(bid_id)
    return_id = database[:projects].insert(status: 'Draft', bid_id: bid_id)
  end

  let(:migrator) { ::Migrator.new }

  let(:migrated_bid_id) do
    database[:projects]
      .all
      .first[:bid_id]
  end

  context 'stripping leading zeroes' do
    example 1 do
      synchronize_to_non_migrated_version
      create_project('AC/MV/035')
      synchronize_to_migrated_version

      expect(migrated_bid_id).to eq('AC/MV/35')
    end

    example 2 do
      synchronize_to_non_migrated_version
      create_project('HIF/MV/000110')
      synchronize_to_migrated_version

      expect(migrated_bid_id).to eq('HIF/MV/110')
    end
  end

  context 'already stripped zeroes' do
    example 1 do
      synchronize_to_non_migrated_version
      create_project('AC/MV/100')
      synchronize_to_migrated_version

      expect(migrated_bid_id).to eq('AC/MV/100')
    end

    example 2 do
      synchronize_to_non_migrated_version
      create_project('HIF/MV/20')
      synchronize_to_migrated_version

      expect(migrated_bid_id).to eq('HIF/MV/20')
    end
  end
end
