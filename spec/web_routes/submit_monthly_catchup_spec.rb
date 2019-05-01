describe 'submit monthly_catchup' do
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

  let(:submit_monthly_catchup_spy) { spy }

  before do
    stub_instances(HomesEngland::UseCase::SubmitMonthlyCatchup, submit_monthly_catchup_spy)
    stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)
    stub_instances(LocalAuthority::Gateway::InMemoryAPIKeyGateway, api_key_gateway_spy)
  end

  context 'calls the submit use case' do
    example 1 do
      post '/monthly-catch-up/submit', { project_id: 3, monthly_catchup_id: 2 }.to_json, 'HTTP_API_KEY' => api_key
      expect(submit_monthly_catchup_spy).to have_received(:execute).with(monthly_catchup_id: 2)
    end

    example 2 do
      post '/monthly-catch-up/submit', { project_id: 7, monthly_catchup_id: 9 }.to_json, 'HTTP_API_KEY' => api_key
      expect(submit_monthly_catchup_spy).to have_received(:execute).with(monthly_catchup_id: 9)
    end
  end

  context 'API Key' do
    context 'example 1' do
      before do
        post '/monthly-catch-up/submit',
          { project_id: 99, monthly_catchup_id: 9 }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 200' do
          expect(last_response.status).to eq(200)
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
          post '/monthly-catch-up/submit',
            { project_id: 99, monthly_catchup_id: 9 }.to_json
            expect(last_response.status).to eq(400)
        end
      end
    end
    context 'example 2' do
      before do
        post '/monthly-catch-up/submit',
          { project_id: 42, monthly_catchup_id: 1 }.to_json, 'HTTP_API_KEY' => api_key
      end

      context 'is valid' do
        it 'responds with a 200' do
          expect(last_response.status).to eq(200)
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
          post '/monthly-catch-up/submit',
            { project_id: 52, monthly_catchup_id: 2 }.to_json
            expect(last_response.status).to eq(400)
        end
      end
    end
  end
end
