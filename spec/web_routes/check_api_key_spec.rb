require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Checking an API key' do
  let(:create_claim_spy) { spy(execute: { claim_id: 0 }) }

  let(:apikey_values) { { valid: true, email: 'myemail@email.jp', role: 'Local Authority' } }
  let(:check_api_key_spy) { spy(execute: apikey_values) }

  let(:api_key_gateway_spy) { nil }

  let(:api_key) { 'Cats' }

  before do
      stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)
      stub_instances(LocalAuthority::Gateway::InMemoryAPIKeyGateway, api_key_gateway_spy)
  end

  context 'API Key' do
    context 'example 1' do

      before do
        post '/apikey/check',
             { project_id: 1, claim_data: { cats: 'Meow' } }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        let(:apikey_values) { { valid: true, email: 'myemail@email.jp', role: 'Local Authority' } }
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        it 'runs the check api key use case' do
          expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: 1)
        end

        it 'returns the email and role' do
          response_body = JSON.parse(last_response.body)
          expect(response_body['email']).to eq('myemail@email.jp')
          expect(response_body['role']).to eq('Local Authority')
        end
      end

      context 'is invalid' do
        let(:check_api_key_spy) { spy(execute: { valid: false }) }

        it 'responds with a 401' do
          expect(last_response.status).to eq(401)
        end
      end

      context 'is not in header' do
        it 'responds with a 400' do
          post('/apikey/check', { project_id: 1, claim_data: { cats: 'Meow' } }.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end

    context 'example 2' do
      before do
        post '/apikey/check',
             { project_id: 6, claim_data: { cats: 'Meow' } }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        let(:api_key) { 'Dogs' }
        let(:apikey_values) { { valid: true, email: 'dennis@bell.net', role: 'Homes England' } }
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        it 'runs the check api key use case' do
          expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: 6)
        end

        it 'returns the email and role' do
          response_body = JSON.parse(last_response.body)
          expect(response_body['email']).to eq('dennis@bell.net')
          expect(response_body['role']).to eq('Homes England')
        end
      end

      context 'is invalid' do
        let(:check_api_key_spy) { spy(execute: { valid: false }) }

        it 'responds with a 401' do
          expect(last_response.status).to eq(401)
        end
      end

      context 'is not in header' do
        it 'responds with a 400' do
          post('/apikey/check', { project_id: 6, claim_data: { cats: 'Meow' } }.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end
  end
end
