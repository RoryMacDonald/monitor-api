# frozen-string-literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a baseline' do
  let(:submit_baseline_spy) { spy(execute: nil) }

  before do
    stub_const(
      'HomesEngland::UseCase::SubmitBaseline',
      double(new: submit_baseline_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )
  end

  context 'If API key is invalid' do
    let(:check_api_key_spy) { spy(execute: { valid: false })}

    it 'returns 401' do
      post 'baseline/submit', { baseline_id: '1' }.to_json, 'HTTP_API_KEY' => 'notSoSecret'

      expect(last_response.status).to eq(401)
    end
  end

  context 'If API key is valid' do
    let(:check_api_key_spy) { spy(execute: { valid: true })}

    it 'returns 400 when submitting nothing' do
      post 'baseline/submit', nil, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(400)
    end

    it 'returns 200 when submitting a valid id' do
      post 'baseline/submit', { baseline_id: '1' }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(200)
    end

    context 'example one' do
      it 'will run submit baseline use case with id' do
        post '/baseline/submit', { baseline_id: '1' }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(submit_baseline_spy).to have_received(:execute).with(id: 1)
      end
    end


    context 'example two' do
      it 'will run submit baseline use case with id' do
        post '/baseline/submit', { baseline_id: '5' }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(submit_baseline_spy).to have_received(:execute).with(id: 5)
      end
    end
  end
end
