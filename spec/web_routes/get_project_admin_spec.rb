# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting project admin data' do
  let(:check_api_key_stub) { double(execute: { valid: token_valid }) }
  let(:get_project_spy) { spy(execute: project) }
  let(:project) { nil }
  let(:project_id) { nil }
  let(:schema) { nil }
  let(:token_valid) { true }

  before do
    stub_instances(UI::UseCase::GetProject, get_project_spy)
    stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_stub)
  end

  context 'with an non existent id' do
    before do
      header 'API_KEY', 'superSecret'
      get "/project/admin/get?id=#{project_id}"
    end

    let(:project_id) { 42 }
    let(:get_project_spy) { spy(execute: nil) }

    it 'should return 404' do
      expect(last_response.status).to eq(404)
    end
  end

  context 'with no valid token' do
    before do
      header 'API_KEY', 'invalid.api.key'
      get "/project/admin/get?id=#{project_id}"
    end

    let(:token_valid) { false }

    it 'Returns a 401' do
      expect(last_response.status).to eq(401)
    end
  end

  context 'with an valid id' do
    context 'example one' do
      before do
        header 'API_KEY', 'superSecret'
        get "/project/admin/get?id=#{project_id}"
      end

      let(:project_id) { 42 }
      let(:project) do
        {
          type: 'cat',
          status: 'Draft',
          bid_id: 'HIF/MV/13',
          data: { cats_go: 'meow', dogs_go: 'woof' },
          admin_data: { contact: 'name'},
          admin_schema: { ducks: 'quack' },
          schema: { cats: 'go meow' },
          timestamp: '123'
        }
      end

      it 'should find the project with the given id' do
        expect(get_project_spy).to have_received(:execute).with(hash_including(id: 42))
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should have project in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['adminData']['contact']).to eq('name')
      end

      it 'should have a timestamp in body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['timestamp']).to eq('123')
      end

      it 'should have the admin schema in the return body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['adminSchema']['ducks']).to eq('quack')
      end
    end

    context 'example two' do
      before do
        header 'API_KEY', 'superSecret'
        get "/project/admin/get?id=#{project_id}"
      end

      let(:project_id) { 52 }
      let(:project) do
        {
          type: 'cat',
          status: 'Draft',
          bid_id: 'HIF/MV/13',
          data: { cats_go: 'meow', dogs_go: 'woof' },
          admin_data: { email: 'name@catfactory.com'},
          admin_schema: { name: 'mc fluffyson' },
          schema: { cats: 'go meow' },
          timestamp: '56789'
        }
      end

      it 'should find the project with the given id' do
        expect(get_project_spy).to have_received(:execute).with(hash_including(id: 52))
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should have project in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['adminData']['email']).to eq('name@catfactory.com')
      end

      it 'should have a timestamp in body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['timestamp']).to eq('56789')
      end

      it 'should have the admin schema in the return body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['adminSchema']['name']).to eq('mc fluffyson')
      end
    end
  end
end
