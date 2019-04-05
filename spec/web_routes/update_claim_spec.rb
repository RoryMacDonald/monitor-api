# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Updating a claim' do
  let(:update_claim_spy) { spy }

  let(:sanitise_data_spy) { spy(execute: { dogs: 'meow' })}

  before do
    stub_instances(Common::UseCase::SanitiseData, sanitise_data_spy)
    stub_instances(UI::UseCase::UpdateClaim, update_claim_spy)
    stub_instances(LocalAuthority::UseCase::CheckApiKey, double(execute: {valid: true}))
  end

  context 'with invalid' do
    it 'claim data' do
      post '/claim/update', { claim_id: 1, claim_data: nil }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(400)
    end
    it 'claim id' do
      post '/claim/update', { claim_id: nil, claim_data: {} }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(400)
    end
  end

  context 'with valid input data' do
    it 'claim 200' do
      post '/claim/update', { claim_id: 1, claim_data: {} }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(200)
    end

    context 'example one' do
      it 'will  sanitise the data' do
        post '/claim/update', { claim_id: 1, claim_data: { cats: 'meow' } }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(sanitise_data_spy). to have_received(:execute).with(data: { cats: 'meow' })        
      end

      it 'will run update claim use case' do
        post '/claim/update', { claim_id: 1, claim_data: { cats: 'meow' } }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(update_claim_spy).to have_received(:execute).with(
          claim_id: 1, claim_data: { dogs: 'meow' }
        )
      end
    end

    context 'example two' do
      it 'will  sanitise the data' do
        post '/claim/update', { claim_id: 1, claim_data: { dogs: 'woof' } }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(sanitise_data_spy). to have_received(:execute).with(data: { dogs: 'woof' })        
      end

      it 'will run update claim use case' do
        post '/claim/update', { claim_id: 1, claim_data: { dogs: 'woof' } }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(update_claim_spy).to have_received(:execute).with(
          claim_id: 1, claim_data: { dogs: 'meow' }
        )
      end
    end
  end
end
