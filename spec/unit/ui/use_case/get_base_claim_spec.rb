# frozen_string_literal: true

describe UI::UseCase::GetBaseClaim do
  let(:claim_gateway_spy) { spy(find_by: schema) }
  let(:project_gateway_spy) { spy(find_by: project) }
  let(:use_case) do 
    described_class.new(
      claim_gateway: claim_gateway_spy,
      project_gateway: project_gateway_spy
    )
  end

  let(:response) { use_case.execute(project_id: project_id) }

  before { response }

  context 'Example 1' do
    let(:schema) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          kitty: 'purr',
          duckies: 'quack',
          doggos: 'woof'
        }
      end
    end

    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
      end
    end

    let(:project_id) { 12 }

    it 'call the project gateway to get the project type' do 
      expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
    end

    it 'calls the claim gateway to get the schema' do 
      expect(claim_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end

    it 'will return the project id' do
      expect(response[:base_claim][:project_id]).to eq(12)
    end

    it 'will return the schema' do
      expect(response[:base_claim][:schema]).to eq(schema.schema)
    end

    it 'will return blank data' do 
      expect(response[:base_claim][:data]).to eq({})
    end
  end

  context 'Example 2' do
    let(:schema) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          birdies: 'squark',
          butterflies: 'flap',
          mice: 'squeak'
        }
      end
    end

    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'ac'
      end
    end
    
    let(:project_id) { 456 }

    it 'call the project gateway to get the project type' do 
      expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
    end

    it 'calls the claim gateway to get the schema' do 
      expect(claim_gateway_spy).to have_received(:find_by).with(type: 'ac')
    end

    it 'will return the project id' do
      expect(response[:base_claim][:project_id]).to eq(456)
    end

    it 'will return the schema' do
      expect(response[:base_claim][:schema]).to eq(schema.schema)
    end

    it 'will return blank data' do 
      expect(response[:base_claim][:data]).to eq({})
    end
  end
end
