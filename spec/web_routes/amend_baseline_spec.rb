# frozen-string-literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Ammending a baseline' do
  let(:amend_baseline_spy) { spy(execute: {success: true}) }

  before do
    stub_const(
      'HomesEngland::UseCase::AmendBaseline',
      double(new: amend_baseline_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )
  end

  context 'If API key is invalid' do
    let(:check_api_key_spy) { spy(execute: { valid: false })}

    it 'returns 401' do
      post 'baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'notSoSecret'

      expect(last_response.status).to eq(401)
    end
  end

  context 'If API key is valid' do
    let(:check_api_key_spy) { spy(execute: { valid: true })}

    it 'returns 400 when submitting nothing' do
      post 'baseline/amend', nil, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(400)
    end

    it 'returns 200 when submitting a valid id' do
      post 'baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(200)
    end

    context 'example one' do
      it 'will run amend baseline use case with project_id and data' do
        post '/baseline/amend', { project_id: '1' }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(amend_baseline_spy).to have_received(:execute).with(
          project_id: 1
          )
      end

      let(:amend_baseline_spy) { spy(execute: {success: true, id: 34, errors: [:incorrect_timestamp], timestamp: 3}) }
      
      it 'returns a status of 200' do
        post '/baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(last_response.status).to eq(200)        
      end

      it 'returns the id of the baseline' do
        post '/baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        response_body = JSON.parse(last_response.body)
        
        expect(response_body['baselineId']).to eq(34)        
      end

      it 'returns the timestamp' do
        post '/baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        response_body = JSON.parse(last_response.body)
        
        expect(response_body['timestamp']).to eq(3)        
      end


      it 'returns any errors' do
        post '/baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        response_body = JSON.parse(last_response.body)
        
        expect(response_body['errors']).to eq(['incorrect_timestamp'])        
      end
    end


    context 'example two' do
      it 'will run amend baseline use case with project_id and data' do
        post '/baseline/amend', { project_id: '5'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(amend_baseline_spy).to have_received(:execute).with(
          project_id: 5
        )
      end

      let(:amend_baseline_spy) { spy(execute: {success: true, id: 56, timestamp: 44444, errors: []}) }
      
      it 'returns the id from the baseline' do
        post '/baseline/amend', { project_id: '5'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        response_body = JSON.parse(last_response.body)
        
        expect(response_body['baselineId']).to eq(56)        
      end

      it 'returns the timestamp' do
        post '/baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        response_body = JSON.parse(last_response.body)
        
        expect(response_body['timestamp']).to eq(44444)        
      end


      it 'returns any errors' do
        post '/baseline/amend', { project_id: '1'}.to_json, 'HTTP_API_KEY' => 'superSecret'
        response_body = JSON.parse(last_response.body)
        
        expect(response_body['errors']).to eq([])        
      end

    end
  end
end
