# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Creating a new project' do
  let(:check_api_key_stub) { double(execute: { valid: token_valid }) }
  let(:infrastructures) { nil }
  let(:get_infrastructures_spy) do
    spy(execute: {
      infrastructures: infrastructures
    })
  end

  before do
    stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_stub)
    stub_instances(LocalAuthority::UseCase::GetInfrastructures, get_infrastructures_spy)

    #header 'API_KEY', 'superSecret'
  end

  context 'with no valid token' do
    let(:token_valid) { false }

    it 'Returns a 401' do
      header 'API_KEY', 'invalidKey'
      get '/project/1/infrastructures'
      expect(last_response.status).to eq(401)
    end
  end

  context 'with a valid token' do
    let(:token_valid) { true }

    context 'example 1' do
      let(:infrastructures) do
        [
          {
            information: 'some data'
          }
        ]
      end

      it 'calls the get infrastructures use case' do
          header 'API_KEY', 'secretKey'
          get '/project/3/infrastructures'
          expect(get_infrastructures_spy).to have_received(:execute).with(project_id: 3)
      end

      it 'returns the correct status' do
        header 'API_KEY', 'secretKey'
        get '/project/3/infrastructures'
        expect(last_response.status).to eq(200)
      end

      it 'returns the infrastructures' do
        header 'API_KEY', 'secretKey'
        get '/project/3/infrastructures'
        response = JSON.parse(last_response.body)

        expect(response).to eq(
          'infrastructures' => [
            {
              'information' => 'some data'
            }
          ]
        )
      end
    end

    context 'example 2' do
      let(:infrastructures) do
        [
          {
            'information' => 'data'
          },
          {
            'information' => 'other data'
          }
        ]
      end

      it 'calls the get infrastructures use case' do
          header 'API_KEY', 'secretKey'
          get '/project/7/infrastructures'
          expect(get_infrastructures_spy).to have_received(:execute).with(project_id: 7)
      end

      it 'returns the correct status' do
        header 'API_KEY', 'secretKey'
        get '/project/9/infrastructures'
        expect(last_response.status).to eq(200)
      end

      it 'returns the infrastructures' do
        header 'API_KEY', 'secretKey'
        get '/project/9/infrastructures'
        response = JSON.parse(last_response.body)

        expect(response).to eq(
          'infrastructures' => [
            {
              'information' => 'data'
            },
            {
              'information' => 'other data'
            }
          ]
        )
      end
    end
  end
end
