# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a base return' do
  let(:get_base_claim_spy) { spy(execute: base_claim) }

  let(:check_api_key_spy) { spy(execute:{ valid: true })}


  before do
    stub_const(
      'UI::UseCase::GetBaseClaim',
      double(new: get_base_claim_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )
  end

  context 'non existent project ID' do 
    let(:project_id) { 222234 }
    let(:base_claim) { {} } 

    before do
      get "project/#{project_id}/claim", {}, { 'HTTP_API_KEY' => 'Cats' }
    end

    it 'should return 404' do
      expect(last_response.status).to eq(404)
    end
  end

  context 'real project ID' do
    context 'example 1' do 
      let(:project_id) { 1 }
      let(:base_claim) do
        {
          base_claim: {
            a_claim: 'Im a claim'
          }
        }
      end
  
      before do
        get "project/#{project_id}/claim", {}, { 'HTTP_API_KEY' => 'Cats' }
      end
  
      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end
  
      it 'should call the get base claim use case with the project id' do
        expect(get_base_claim_spy).to have_received(:execute).with(project_id: 1)
      end
  
      it 'should return the data from the get base claim use case' do
        expect(last_response.body).to eq({
          baseClaim: { a_claim: 'Im a claim' }
        }.to_json)
      end
    end

    context 'example 2' do 
      let(:project_id) { 5 }
      let(:base_claim) do
        {
          base_claim: {
            cats: 'meows',
            kittens: 'purr'
          }
        }
      end
  
      before do
        get "project/#{project_id}/claim", {}, { 'HTTP_API_KEY' => 'Cats' }
      end
  
      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end
  
      it 'should call the get base claim use case with the project id' do
        expect(get_base_claim_spy).to have_received(:execute).with(project_id: 5)
      end
  
      it 'should return the data from the get base claim use case' do
        expect(last_response.body).to eq({
          baseClaim: {
            cats: 'meows',
            kittens: 'purr'
          }
        }.to_json)
      end
    end
  end
end