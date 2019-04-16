# frozen-string-literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting the project overview' do
  let(:project_overview_spy) { spy(execute: found_overview) }
  let(:found_overview) { nil }

  before do
    stub_const(
      'HomesEngland::UseCase::GetProjectOverview',
      double(new: project_overview_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )
  end

  context 'If API key is invalid' do
    let(:check_api_key_spy) { spy(execute: { valid: false }) }

    it 'returns 401' do
      header 'API_KEY', 'noSoSecret'
      get 'project/1/overview'

      expect(last_response.status).to eq(401)
    end
  end

  context 'If API key is valid' do
    let(:check_api_key_spy) { spy(execute: { valid: true }) }

    context 'Example one' do
      before do
        header 'API_KEY', 'MeGaSeCrEt'
        get 'project/1/overview'
      end

      it 'Passes the project ID to the get project overview use case' do
        expect(project_overview_spy).to have_received(:execute).with(id: 1)
      end

      context 'No project is found' do
        it 'Returns 404' do
          expect(last_response.status).to eq(404)
        end
      end

      context 'A project is found' do
        let(:found_overview) do
          {
            name: 'Meow',
            status: 'Submitted',
            type: 'ac',
            data: { this_is: 'some data' },
            returns: [{ id: 1, status: 'Draft' }],
            baselines: [{ id: 2, status: 'Submitted' }],
            claims: [{ id: 3, status: 'Submitted' }]
          }
        end

        let(:response) do
          JSON.parse(last_response.body)
        end

        it 'Returns a 200 response' do
          expect(last_response.status).to eq(200)
        end

        it 'Contains the project name in the response' do
          expect(response['name']).to eq('Meow')
        end

        it 'Contains the project status in the response' do
          expect(response['status']).to eq('Submitted')
        end

        it 'Contains the project type in the response' do
          expect(response['type']).to eq('ac')
        end

        it 'Contains the project data in the response' do
          expect(response['data']).to eq('this_is' => 'some data')
        end

        it 'Contains the project returns in the response' do
          expect(response['returns']).to eq([{ 'id' => 1, 'status' => 'Draft' }])
        end

        it 'Contains the project baselines in the response' do
          expect(response['baselines']).to eq([{ 'id' => 2, 'status' => 'Submitted' }])
        end


        it 'Contains the claims returns in the response' do
          expect(response['claims']).to eq([{ 'id' => 3, 'status' => 'Submitted' }])
        end
      end
    end

    context 'Example two' do
      before do
        header 'API_KEY', 'MeGaSeCrEt'
        get 'project/5/overview'
      end

      it 'Passes the project ID to the get project overview use case' do
        expect(project_overview_spy).to have_received(:execute).with(id: 5)
      end

      context 'No project is found' do
        it 'Returns 404' do
          expect(last_response.status).to eq(404)
        end
      end

      context 'A project is found' do
        let(:found_overview) do
          {
            name: 'Woof',
            status: 'Submitted',
            type: 'hif',
            data: { some_more: 'data' },
            returns: [{ id: 6, status: 'Submitted' }],
            baselines: [{ id: 7, status: 'Submitted' }],
            claims: [{ id: 8, status: 'Draft' }]
          }
        end

        let(:response) do
          JSON.parse(last_response.body)
        end

        it 'Returns a 200 response' do
          expect(last_response.status).to eq(200)
        end

        it 'Contains the project name in the response' do
          expect(response['name']).to eq('Woof')
        end

        it 'Contains the project status in the response' do
          expect(response['status']).to eq('Submitted')
        end

        it 'Contains the project type in the response' do
          expect(response['type']).to eq('hif')
        end

        it 'Contains the project data in the response' do
          expect(response['data']).to eq('some_more' => 'data')
        end

        it 'Contains the project returns in the response' do
          expect(response['returns']).to eq([{ 'id' => 6, 'status' => 'Submitted' }])
        end

        it 'Contains the project baselines in the response' do
          expect(response['baselines']).to eq([{ 'id' => 7, 'status' => 'Submitted' }])
        end


        it 'Contains the claims returns in the response' do
          expect(response['claims']).to eq([{ 'id' => 8, 'status' => 'Draft' }])
        end
      end
    end
  end
end
