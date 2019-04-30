require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

fdescribe 'Creating a review' do
  let(:api_key_gateway_spy) { nil }
  let(:api_key) { 'Cats' }
  let(:check_api_key_spy) { spy }

  ENV['HTTP_API_KEY'] = 'supersecret'

  def set_correct_auth_header
    header 'API_KEY', ENV['HTTP_API_KEY']
  end

  def set_incorrect_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY'] + 'make_key_invalid'
  end
  let(:review_id) { 2 }
  let(:create_new_rm_review_spy) {spy(execute: {id: review_id})}

  before do
    stub_instances(
      HomesEngland::UseCase::CreateNewRmReview, create_new_rm_review_spy
    )
    stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)
    stub_instances(LocalAuthority::Gateway::InMemoryAPIKeyGateway, api_key_gateway_spy)
  end

  context 'example 1' do
    it 'calls the review usecase' do
      post 'review/create', { project_id: 4, data:{ date: '12/04/2018'} }.to_json, 'HTTP_API_KEY' => api_key
      expect(create_new_rm_review_spy).to have_received(:execute).with(project_id: 4, review_data:{ date: '12/04/2018'} )
    end

    it 'returns created review id' do
      post 'review/create', { project_id: 8, data:{ date: '09/07/2018'} }.to_json, 'HTTP_API_KEY' => api_key
      expect(JSON.parse(last_response.body)).to eq({'id' => 2})
    end
  end

  context 'example 2' do
    let(:review_id) { 6 }

    it 'calls the review usecase' do
      post 'review/create', { project_id: 1, data: {}}.to_json, 'HTTP_API_KEY' => api_key
      expect(create_new_rm_review_spy).to have_received(:execute).with(project_id: 1, review_data: {})
    end

    it 'returns created review id' do
      post 'review/create', { project_id: 99, data:{ date: '11/02/2018'} }.to_json, 'HTTP_API_KEY' => api_key
      expect(JSON.parse(last_response.body)).to eq({'id' => 6})
    end
  end

  context 'API Key' do
    context 'example 1' do
      before do
        post 'review/create',
          { project_id: 99, review_data:{ date: '11/02/2018'} }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: 99)
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: 99)
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
          post 'review/create',
            { project_id: 99, review_data:{ date: '11/02/2018'} }.to_json
            expect(last_response.status).to eq(400)
        end
      end
    end
    context 'example 2' do
      before do
        post 'review/create',
          { project_id: 42, review_data:{ date: '05/17/2018'} }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: 42)
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: 42)
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
          post 'review/create',
            { project_id: 52, review_data:{ date: '10/09/2018'} }.to_json
            expect(last_response.status).to eq(400)
        end
      end
    end
  end
end
