describe 'Migration 22' do
  include_context 'with database'

   def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 21)
  end

   def synchronize_to_migrated_version
    migrator.migrate_to(database, 22)
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

   context 'links in HIF RM Baseline to arrays' do
    let(:data) do
      {
        rmBaseline: {
          mhclgLinks: {mhclg: 'cat'},
          ogdLinks: {odg: 'dog'},
          otherGovDepts: {gov: 'fish'},
          housingPolicyAreas: {house: 'shark'},
          heProgrammeLinks: {programmes: 'many'}
        }
      }
    end

     it 'migrates successfully' do
      expect(migrated_baseline_data).to eq({
        rmBaseline: {
          mhclgLinks: {mhclg: 'cat'},
          mhclgProgrammeLinks: [{mhclg: 'cat'}],
          ogdLinks: {odg: 'dog'},
          ogdProgrammeLinks: [{odg: 'dog'}],
          otherGovDepts: {gov: 'fish'},
          otherLinkedGovDepts: [{gov: 'fish'}],
          housingPolicyAreas: {house: 'shark'},
          linkedHousingPolicyAreas:[{house: 'shark'}],
          heProgrammeLinks: {programmes: 'many'},
          heProgrammeLinksMultiple: [{programmes: 'many'}]
        }
      })
    end
  end
end
