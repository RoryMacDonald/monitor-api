require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a review' do
  let(:api_key) { 'Cats' }
  let(:check_api_key_spy) { spy }
  let(:get_rm_review_spy) { spy }
  let(:api_key_gateway_spy) { nil }

  ENV['HTTP_API_KEY'] = 'supersecret'

  def set_correct_auth_header
    header 'API_KEY', ENV['HTTP_API_KEY']
  end

  def set_incorrect_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY'] + 'make_key_invalid'
  end

  before do
    stub_instances(
      UI::UseCase::UiGetReview, get_rm_review_spy
    )
    stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)
    stub_instances(LocalAuthority::Gateway::InMemoryAPIKeyGateway, api_key_gateway_spy)
  end

  context 'example 1' do
    let(:review_id) { 1 }
    let(:review_date) { '01/03/1997' }
    let(:project_id) { 2 }
    let(:get_rm_review_spy) do
      spy(
        execute: {
          id: review_id,
          project_id: project_id,
          data: { date: review_date },
          status: 'Draft'
        }
      )
    end

    before { get "review/get?id=#{project_id}&review_id=#{review_id}", {}.to_json, 'HTTP_API_KEY' => api_key }

    it 'calls the get review use case' do
      expect(get_rm_review_spy).to have_received(:execute).with(project_id: project_id, review_id: review_id)
    end

    it 'returns the review' do
      expect(JSON.parse(last_response.body)).to eq(
        {
          'id' => review_id,
          'project_id' => project_id,
          'data' => { 'date' => review_date },
          'status' => 'Draft'
        }
      )
    end
  end

  context 'example 2' do
    let(:review_id) { 230 }
    let(:review_date) { '13/09/1993' }
    let(:project_id) { 42 }
    let(:get_rm_review_spy) do
      spy(
        execute: {
          id: review_id,
          project_id: project_id,
          data: { date: review_date },
          status: 'Draft'
        }
      )
    end

    before { get "review/get?id=#{project_id}&review_id=#{review_id}", {}.to_json, 'HTTP_API_KEY' => api_key }

    it 'calls the get review use case' do
      expect(get_rm_review_spy).to have_received(:execute).with(project_id: project_id, review_id: review_id)
    end

    it 'returns the review' do
      expect(JSON.parse(last_response.body)).to eq(
        {
          'id' => review_id,
          'project_id' => project_id,
          'data' => { 'date' => review_date },
          'status' => 'Draft'
        }
      )
    end
  end

  context 'API Key' do
    context 'example 1' do
      let(:project_id) { 111 }

      before do
        get "review/get?id=#{project_id}&review_id=13", {}.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 200' do
          expect(last_response.status).to eq(200)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: project_id.to_s)
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: project_id.to_s)
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
          get 'review/get?id=78&review_id=13'
          expect(last_response.status).to eq(400)
        end
      end
    end

    context 'example 2' do
      let(:project_id) { 100 }

      before do
        get "review/get?id=#{project_id}&review_id=22", {}.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 200' do
          expect(last_response.status).to eq(200)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: project_id.to_s)
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: project_id.to_s)
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
          get 'review/get?id=78&review_id=13'
          expect(last_response.status).to eq(400)
        end
      end
    end
  end
end
