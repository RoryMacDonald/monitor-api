# frozen_string_literal: true

describe UI::UseCase::GetBaseClaim do
  let(:claim_gateway_spy) { spy(find_by: schema) }
  let(:project_gateway_spy) { spy(execute: project) }
  let(:base_claim) do 
    {
      base_claim: {
        id: project_id,
        data: data
      }
    }
  end
  
  let(:get_base_claim_spy) { spy(execute: base_claim) }
  let(:use_case) do 
    described_class.new(
      claim_gateway: claim_gateway_spy,
      project_gateway: project_gateway_spy,
      get_base_claim: get_base_claim_spy
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

    let(:data) do
      {
        base_data: 'my previous data'
      }
    end

    let(:project) do
      {
        type: 'hif'
      }
    end

    let(:project_id) { 12 }

    it 'call the project gateway to get the project type' do 
      expect(project_gateway_spy).to have_received(:execute).with(id: project_id)
    end

    it 'calls the claim gateway to get the schema' do 
      expect(claim_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end

    it 'calls the core get base calims usecase' do 
      expect(get_base_claim_spy).to have_received(:execute).with(project_id: 12)
    end

    it 'will return the project id' do
      expect(response[:base_claim][:project_id]).to eq(12)
    end

    it 'will return the schema' do
      expect(response[:base_claim][:schema]).to eq(schema.schema)
    end

    it 'will return the data given by the get base claim use case' do 
      expect(response[:base_claim][:data]).to eq(data)
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

    let(:data) do 
      {
        new_claim: {
          a_claim: 'with data'
        }
      }
    end

    let(:project) do
      {
        type: 'ac'
      }
    end
    
    let(:project_id) { 456 }

    it 'call the project gateway to get the project type' do 
      expect(project_gateway_spy).to have_received(:execute).with(id: project_id)
    end

    it 'calls the claim gateway to get the schema' do 
      expect(claim_gateway_spy).to have_received(:find_by).with(type: 'ac')
    end

    it 'calls the core get base calims usecase' do 
      expect(get_base_claim_spy).to have_received(:execute).with(project_id: 456)
    end

    it 'will return the project id' do
      expect(response[:base_claim][:project_id]).to eq(456)
    end

    it 'will return the schema' do
      expect(response[:base_claim][:schema]).to eq(schema.schema)
    end

    it 'will return the data given by the get base claim use case' do 
      expect(response[:base_claim][:data]).to eq(data)
    end
  end
end
