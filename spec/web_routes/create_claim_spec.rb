# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Creating claims' do
  let(:create_claim_spy) { spy(execute: { claim_id: 0 }) }
  let(:check_api_key_spy) { spy }
  let(:api_key_gateway_spy) { nil }
  let(:api_key) { 'Cats' }
  let(:sanitised_data) {{}}
  let(:sanitise_data_spy) { spy(execute: sanitised_data)}

  before do
      stub_instances(Common::UseCase::SanitiseData, sanitise_data_spy)
      stub_instances(UI::UseCase::CreateClaim, create_claim_spy)
      stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)
      stub_instances(LocalAuthority::Gateway::InMemoryAPIKeyGateway, api_key_gateway_spy)
  end

  context 'API Key' do
    context 'example 1' do
      before do
        post '/claim/create',
             { project_id: 1, claim_data: { cats: 'Meow' } }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: 1)
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: 1)
          end
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
          post('/claim/create', { project_id: 1, claim_data: { cats: 'Meow' } }.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end

    context 'example 2' do
      before do
        post '/claim/create',
             { project_id: 6, claim_data: { cats: 'Meow' } }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: 6)
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: 6)
          end
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
          post('/claim/create', { project_id: 6, claim_data: { cats: 'Meow' } }.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end
  end

  it 'Will claim a 400 if we pass invalid input' do
    post '/claim/create', nil, 'HTTP_API_KEY' => api_key
    expect(last_response.status).to eq(400)
  end

  context 'with a single claim' do
    context 'example 1' do
      let(:create_claim_spy) { spy(execute: { claim_id: 0 }) }
      let(:sanitised_data) { { dogs: 'Woof' }}

      before do
        post '/claim/create',
             { project_id: 1, data: { cats: 'Meow' } }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'sanitises the data' do
        expect(sanitise_data_spy).to have_received(:execute).with(
          data: { cats: 'Meow' }
        )
      end

      it 'passes sanitised data to CreateClaim' do
        expect(create_claim_spy).to have_received(:execute).with(project_id: 1, claim_data: { dogs: 'Woof' })
      end

      it 'will claim a 201' do
        expect(last_response.status).to eq(201)
      end

      it 'will return json with id' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['id']).to eq(0)
      end
    end

    context 'example 2' do
      let(:create_claim_spy) { spy(execute: { claim_id: 3 }) }
      let(:sanitised_data) { {cats: 'Meow'} }

      before do
        post '/claim/create',
             { project_id: 3, data: { dogs: 'Woof' } }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'sanitises the data' do 
        expect(sanitise_data_spy).to have_received(:execute).with(
          data: { dogs: 'Woof' }
        )
      end

      it 'passes sanitised data to CreateClaim' do
        expect(create_claim_spy).to have_received(:execute).with(project_id: 3, claim_data: {cats: 'Meow'})
      end

      it 'will claim a 201' do
        expect(last_response.status).to eq(201)
      end

      it 'will return json with id' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['id']).to eq(3)
      end
    end
  end
end
