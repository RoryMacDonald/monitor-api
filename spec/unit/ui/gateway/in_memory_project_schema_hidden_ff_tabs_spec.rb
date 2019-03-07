# frozen_string_literal: true

describe UI::Gateway::InMemoryProjectSchema do
  describe 'When type is ff' do
    context 'Feature flags are not enabled' do
      let(:gateway) { described_class.new }
      let(:schema) { gateway.find_by(type: 'ff') }

      before do
        ENV['FF_SUMMARY_TAB'] = nil
        ENV['FF_INFRAS_TAB'] = nil
        ENV['FF_PLANNING_TAB'] = nil
        ENV['FF_LAND_OWNERSHIP_TAB'] = nil
        ENV['FF_PROCUREMENT_TAB'] = nil
        ENV['FF_DEMOLITION_TAB'] = nil
        ENV['FF_MILESTONES_TAB'] = nil
        ENV['FF_RISKS_TAB'] = nil
        ENV['FF_GRANT_EXPENDITURE_TAB'] = nil
        ENV['FF_OUTPUTS_TAB'] = nil
        ENV['FF_RECOVERY_TAB'] = nil
        ENV['FF_FUNDING_PACKAGE_TAB'] = nil
        ENV['FF_WIDER_SCHEME_TAB'] = nil
      end

      it 'Returns a schema when finding by type ff' do
        expect(schema).not_to be_nil
      end

      it 'Returns a FF schema with a shared data section' do
        expect(schema.schema[:sharedData]).not_to be_empty
      end

      it 'Does not return a FF schema with a summary section' do
        expect(schema.schema[:properties][:summary]).to be_nil
      end

      it 'Does not return a FF schema with a infrastructures section' do
        expect(schema.schema[:properties][:infrastructures]).to be_nil
      end

      it 'Does not return a FF schema with a planning section' do
        expect(schema.schema[:properties][:planning]).to be_nil
      end

      it 'Does not return a FF schema with a land ownership section' do
        expect(schema.schema[:properties][:landOwnership]).to be_nil
      end

      it 'Does not return a FF schema with a procurement section' do
        expect(schema.schema[:properties][:procurement]).to be_nil
      end

      it 'Does not return a FF schema with a milestones section' do
        expect(schema.schema[:properties][:milestones]).to be_nil
      end

      it 'Does not return a FF schema with a demolution and remediation section' do
        expect(schema.schema[:properties][:demolitionRemediation]).to be_nil
      end

      it 'Does not return a FF schema with a risks section' do
        expect(schema.schema[:properties][:risks]).to be_nil
      end

      it 'Does not return a FF schema with a HIF Grant Expenditure section' do
        expect(schema.schema[:properties][:hifGrantExpenditure]).to be_nil
      end

      it 'Does not return a FF schema with a Wider Scheme section' do
        expect(schema.schema[:properties][:widerScheme]).to be_nil
      end

      it 'Does not return a FF schema with a HIF Recovery section' do
        expect(schema.schema[:properties][:hifRecovery]).to be_nil
      end

      it 'Does not return a FF schema with a infrastructure funding package section' do
        expect(schema.schema[:properties][:infraFundingPackage]).to be_nil
      end

      it 'Does not return a FF schema with an outputs section' do
        expect(schema.schema[:properties][:outputs]).to be_nil
      end
    end
  end
end
