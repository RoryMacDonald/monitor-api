# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Checking if Project is valid' do
  let(:check_api_key_spy) { spy }
  let(:api_key_gateway_spy) { nil }
  let(:api_key) { 'Cats' }

  let(:type) { 'hif' }
  let(:project_data) { { cats: 'in hats' } }
  let(:valid_response) { true }
  let(:invalid_paths) { [] }
  let(:pretty_invalid_paths) { [] }
  let(:validate_project_spy) do
    spy(execute: { valid: valid_response,
                   invalid_paths: invalid_paths,
                   pretty_invalid_paths: pretty_invalid_paths })
  end
  before do
    stub_const(
      'UI::UseCase::ValidateProject',
      double(new: validate_project_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )
  end

  context 'API Key' do
    before do
      post '/project/validate', { type: type, data: project_data }.to_json, 'HTTP_API_KEY' => api_key
    end

    context 'is valid' do
      it 'returns with a 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'Example 1' do
      it 'runs the check api key use case' do
        expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats', project_id: nil)
      end
    end

    context 'Example 2' do
      let(:api_key) { 'Dogs' }
      it 'runs the check api key use case' do
        expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs', project_id: nil)
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
        post '/project/validate', { project_id: 1, data: { cats: 'Meow' } }.to_json
        expect(last_response.status).to eq(400)
      end
    end
  end

  context 'given valid data' do
    context 'given a valid project' do
      let(:invalid_paths) { [] }
      before do
        post '/project/validate', { type: type, data: project_data }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'will run validate project use case' do
        expect(validate_project_spy).to have_received(:execute).with(
          type: type,
          project_data: project_data
        )
      end

      it 'returns 200' do
        expect(last_response.status).to eq(200)
      end

      it 'returns json with valid set to true' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['valid']).to eq(true)
      end

      it 'return json with invalid paths as empty array' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['invalidPaths']).to eq([])
      end
    end

    context 'given invalid project' do
      let(:valid_response) { false }
      before do
        post '/project/validate', { type: type, data: project_data }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'will run validate project use case' do
        expect(validate_project_spy).to have_received(:execute).with(
          type: type,
          project_data: project_data
        )
      end

      it 'returns 200' do
        expect(last_response.status).to eq(200)
      end

      it 'returns json with valid set to false' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['valid']).to eq(false)
      end

      context 'Example 1' do
        let(:invalid_paths) do
          [
            [
              :cathouses,
              1,
              :catPlanning,
              :catPlanningNotGranted,
              :catInAHat,
              :hat
            ]
          ]
        end

        let(:pretty_invalid_paths) do
          [
            [
              'Cat Houses',
              'Cat House 2',
              'Cat Planning',
              'Cat Planning Not Granted',
              'Cat In A Hat',
              'Hat'
            ]
          ]
        end

        it 'returns json with correct invalid paths' do
          expected_invalid_paths = [
            [
              'cathouses',
              1,
              'catPlanning',
              'catPlanningNotGranted',
              'catInAHat',
              'hat'
            ]
          ]
          response_body = JSON.parse(last_response.body)
          expect(response_body['invalidPaths']).to eq(expected_invalid_paths)
        end

        it 'returns json with correct prettyInvalidPaths' do
          response_body = JSON.parse(last_response.body)
          expect(response_body['prettyInvalidPaths']).to eq(pretty_invalid_paths)
        end
      end

      context 'Example 2' do
        let(:invalid_paths) do
          [
            [
              :people, 99, :hello, :doggos, :boots
            ]
          ]
        end

        let(:pretty_invalid_paths) do
          [
            %w[
              People
              99
              Hello
              Doggos
              Boots
            ]
          ]
        end

        it 'returns json with correct invalid paths' do
          expected_invalid_paths = [
            [
              'people',
              99,
              'hello',
              'doggos',
              'boots'
            ]
          ]
          response_body = JSON.parse(last_response.body)
          expect(response_body['invalidPaths']).to eq(expected_invalid_paths)
        end

        it 'returns json with correct pretty invalid paths' do
          response_body = JSON.parse(last_response.body)
          expect(response_body['prettyInvalidPaths']).to eq(pretty_invalid_paths)
        end
      end
    end
  end

  context 'given invalid data' do
    context 'with no type of data' do
      before do
        post '/project/validate', { data: 'blah blah' }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'returns 400' do
        expect(last_response.status).to eq(400)
      end
    end

    context 'with no return data' do
      before do
        post '/project/validate', { type: type }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'returns 400' do
        expect(last_response.status).to eq(400)
      end
    end
  end
end
