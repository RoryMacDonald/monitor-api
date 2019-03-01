# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a claim' do
  let(:check_api_key_stub) { double(execute: {valid: true}) }
  let(:type) { '' }
  let(:get_claim_spy) { spy(execute: returned_hash) }
  let(:returned_hash) { { project_id: 1, type: type, data: { cats: 'Meow' }, status: 'Draft', schema: { type: 'object' } } }

  before do
    stub_instances(UI::UseCase::GetClaim, get_claim_spy)
    stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_stub)
  end

  it 'response of 400 when id parameter does not exist' do
    header 'API_KEY', 'superSecret'
    get '/claim/get'
    expect(last_response.status).to eq(400)
  end

  context 'Given one existing claim' do
    let(:returned_hash) { { project_id: 1, type: 'ac', data: { cats: 'Meow' }, status: 'Draft', schema: { type: 'object' } } }

    context 'example 1' do
      let(:response_body) { JSON.parse(last_response.body) }

      before do
        header 'API_KEY', 'superSecret'
        get '/claim/get?claimId=1'
      end

      it 'passes id to GetClaim' do
        expect(get_claim_spy).to have_received(:execute).with(
          hash_including(claim_id: 1)
        )
      end

      it 'responds with 200 when id found' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'returns the correct project_id' do
        expect(response_body['project_id']).to eq(1)
      end

      it 'returns the correct type' do
        expect(response_body['type']).to eq('ac')
      end

      it 'returns the correct data' do
        expect(response_body['data']).to eq('cats' => 'Meow')
      end

      it 'returns the correct schema' do
        expect(response_body['schema']).to eq('type' => 'object')
      end

      it 'returns the correct schema' do
        expect(response_body['status']).to eq('Draft')
      end
    end

    context 'example 2' do
      let(:returned_hash) { { project_id: 1, type: 'hif', data: { dogs: 'Woof' }, status: 'Draft', schema: { type: 'string', title: "Entry" } } }

      let(:type) { 'hif' }

      let(:response_body) { JSON.parse(last_response.body) }

      before do
        header 'API_KEY', 'verySecret'
        get '/claim/get?claimId=1'
      end

      it 'passes data to GetClaim' do
        expect(get_claim_spy).to have_received(:execute).with(
          hash_including(claim_id: 1)
        )
      end

      it 'responds with 200 when id found' do
        expect(last_response.status).to eq(200)
      end

      it 'returns the correct project_id' do
        expect(response_body['project_id']).to eq(1)
      end

      it 'returns the correct type' do
        expect(response_body['type']).to eq('hif')
      end

      it 'returns the correct data' do
        expect(response_body['data']).to eq('dogs' => 'Woof')
      end

      it 'returns the correct schema' do
        expect(response_body['schema']).to eq('type' => 'string', 'title' => 'Entry')
      end

      it 'returns the correct schema' do
        expect(response_body['status']).to eq('Draft')
      end
    end
  end

  context 'Nonexistent claim' do
    let(:returned_hash) { {} }
    it 'responds with 404 when id not found' do
      header 'API_KEY', 'superSecret'
      get '/claim/get?claimId=512'
      expect(last_response.status).to eq(404)
    end
  end
end
