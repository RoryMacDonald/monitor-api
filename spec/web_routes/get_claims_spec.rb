# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting return history' do
  let(:get_claims_spy) { spy(execute: returned_hashes) }

  before do
    stub_const(
      'UI::UseCase::GetClaims',
      double(new: get_claims_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: {valid: true}))
    )

    header 'API_KEY', 'superSecret'
  end

  context 'example 1' do
    let(:returned_hashes) { [{ project_id: 1, data: { cats: 'Meow' } }] }

    before do
      get '/project/1/claims'
    end

    it 'passes the correct id to the use case' do
      expect(get_claims_spy).to have_received(:execute).with(project_id: 1)
    end

    it 'should respond with 200 for a project that exists' do
      expect(last_response.status).to eq(200)
    end

    it 'should pass a cache-control header' do
      expect(last_response.headers['Cache-Control']).to eq('no-cache')
    end

    it 'should respond with an accurate array of hashes' do
      response = Common::DeepSymbolizeKeys.to_symbolized_hash(
        JSON.parse(last_response.body)
      )
      expect(response).to match_array(
        [
          {
            project_id: 1,
            data: { cats: 'Meow' }
          }
        ]
      )
    end
  end

  context 'example 2' do
    let(:returned_hashes) { [{ project_id: 3, data: { cows: 'Moo' } }] }

    before do
      get '/project/3/claims'
    end

    it 'passes the correct id to the use case' do
      expect(get_claims_spy).to have_received(:execute).with(project_id: 3)
    end

    it 'should respond with 200 for a project that exists' do
      expect(last_response.status).to eq(200)
    end

    it 'should pass a cache-control header' do
      expect(last_response.headers['Cache-Control']).to eq('no-cache')
    end

    it 'should respond with an accurate array of hashes' do
      response = Common::DeepSymbolizeKeys.to_symbolized_hash(
        JSON.parse(last_response.body)
      )
      expect(response).to match_array(
        [
          {
            project_id: 3,
            data: { cows: 'Moo' }
          }
        ]
      )
    end
  end

  context 'without any found hashes' do
    let(:returned_hashes) { [] }

    before do
      get '/project/4096/claims'
    end

    it 'should respond with 404 for a project that does not exist' do
      expect(last_response.status).to eq(404)
    end

    it 'should return an empty array' do
      expect(JSON.parse(last_response.body)).to match_array([])
    end
  end
end
