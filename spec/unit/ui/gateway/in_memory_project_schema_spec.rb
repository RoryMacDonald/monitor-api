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

  describe 'When type is ff' do
    let(:gateway) { described_class.new }
    let(:schema) { gateway.find_by(type: 'ff') }

    it 'Returns a schema when finding by type ff' do
      expect(schema).not_to be_nil
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

    it 'Returns a FF schema with a HIF Recovery section' do
      expect(schema.schema[:properties][:hifRecovery]).not_to be_nil
    end

    it 'Returns a FF schema with a infrastructure funding package section' do
      expect(schema.schema[:properties][:infraFundingPackage]).not_to be_nil
    end
  end

  it 'Returns nil when searching for a non existing type' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'cats 4 lyf')
    expect(schema).to be_nil
  end
end
