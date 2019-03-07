# frozen_string_literal: true

describe UI::Gateway::InMemoryProjectSchema do
  it 'Returns a schema when finding by type hif' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'hif')
    expect(schema).not_to be_nil
  end

  it 'Returns a schema when finding by type ac' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'ac')
    expect(schema).not_to be_nil
  end

  fdescribe 'When type is ff' do
    context 'Feature flags are enabled' do
      before do
        ENV['FF_SUMMARY_TAB'] = 'yes'
        ENV['FF_INFRAS_TAB'] = 'yes'
        ENV['FF_PLANNING_TAB'] = 'yes'
        ENV['FF_LAND_OWNERSHIP_TAB'] = 'yes'
        ENV['FF_PROCUREMENT_TAB'] = 'yes'
        ENV['FF_DEMOLITION_TAB'] = 'yes'
        ENV['FF_MILESTONES_TAB'] = 'yes'
        ENV['FF_RISKS_TAB'] = 'yes'
        ENV['FF_GRANT_EXPENDITURE_TAB'] = 'yes'
        ENV['FF_OUTPUTS_TAB'] = 'yes'
        ENV['FF_RECOVERY_TAB'] = 'yes'
        ENV['FF_FUNDING_PACKAGE_TAB'] = 'yes'
        ENV['FF_WIDER_SCHEME_TAB'] = 'yes'
      end

      let(:gateway) { described_class.new }
      let(:schema) { gateway.find_by(type: 'ff') }

      it 'Returns a schema when finding by type ff' do
        expect(schema).not_to be_nil
      end

      it 'Returns a FF schema with a shared data section' do
        expect(schema.schema[:sharedData]).not_to be_empty
      end

      it 'Returns a FF schema with a summary section' do
        expect(schema.schema[:properties][:summary]).not_to be_nil
      end

      it 'Returns a FF schema with a infrastructures section' do
        expect(schema.schema[:properties][:infrastructures]).not_to be_nil
      end

      it 'Returns a FF schema with a planning section' do
        expect(schema.schema[:properties][:planning]).not_to be_nil
      end

      it 'Returns a FF schema with a land ownership section' do
        expect(schema.schema[:properties][:landOwnership]).not_to be_nil
      end

      it 'Returns a FF schema with a procurement section' do
        expect(schema.schema[:properties][:procurement]).not_to be_nil
      end

      it 'Returns a FF schema with a milestones section' do
        expect(schema.schema[:properties][:milestones]).not_to be_nil
      end

      it 'Returns a FF schema with a demolution and remediation section' do
        expect(schema.schema[:properties][:demolitionRemediation]).not_to be_nil
      end

      it 'Returns a FF schema with a risks section' do
        expect(schema.schema[:properties][:risks]).not_to be_nil
      end

      it 'Returns a FF schema with a HIF Grant Expenditure section' do
        expect(schema.schema[:properties][:hifGrantExpenditure]).not_to be_nil
      end

      it 'Returns a FF schema with a Wider Scheme section' do
        expect(schema.schema[:properties][:widerScheme]).not_to be_nil
      end

      it 'Returns a FF schema with a HIF Recovery section' do
        expect(schema.schema[:properties][:hifRecovery]).not_to be_nil
      end

      it 'Returns a FF schema with a infrastructure funding package section' do
        expect(schema.schema[:properties][:infraFundingPackage]).not_to be_nil
      end

      it 'Returns a FF schema with an outputs section' do
        expect(schema.schema[:properties][:outputs]).not_to be_nil
      end
    end

    context 'Feature flags are not enabled' do
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

      let(:gateway) { described_class.new }
      let(:schema) { gateway.find_by(type: 'ff') }

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

  it 'Returns nil when searching for a non existing type' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'cats 4 lyf')
    expect(schema).to be_nil
  end
end
