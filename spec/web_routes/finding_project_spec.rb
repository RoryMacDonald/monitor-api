# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Finding a project' do
  let(:find_project_spy) { spy(execute: project) }
  let(:project) { nil }
  let(:project_id) { nil }
  let(:schema) { nil }
  let(:token_valid) { true }

  before do
    stub_const(
      'UI::UseCase::GetProject',
      double(new: find_project_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: { valid: token_valid }))
    )

    header 'API_KEY', 'superSecret'
    get "/project/find?id=#{project_id}"
  end

  context 'with an non existant id' do
    let(:project_id) { 42 }
    let(:find_project_spy) { spy(execute: nil) }
    let(:get_schema_spy) { spy(execute: nil) }

    it 'should return 404' do
      expect(last_response.status).to eq(404)
    end
  end

  context 'with no valid token' do
    let(:token_valid) { false }

    it 'Returns a 401' do
      expect(last_response.status).to eq(401)
    end
  end

  context 'with an valid id' do
    context 'example one' do
      let(:project_id) { 42 }
      let(:project) do
        {
          type: 'cat',
          status: 'Draft',
          bid_id: 'HIF/MV/13',
          data: { cats_go: 'meow', dogs_go: 'woof' },
          schema: { cats: 'go meow' },
          timestamp: '123'
        }
      end

      it 'should find the project with the given id' do
        expect(find_project_spy).to have_received(:execute).with(id: 42)
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should have project in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['type']).to eq('cat')
        expect(response_body['bid_id']).to eq('HIF/MV/13')
        expect(response_body['status']).to eq('Draft')
        expect(response_body['data']['catsGo']).to eq('meow')
        expect(response_body['data']['dogsGo']).to eq('woof')
      end

      it 'should have a timestamp in body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['timestamp']).to eq('123')
      end

      it 'should have schema in the return body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['schema']['cats']).to eq('go meow')
      end
    end

    context 'example two' do
      let(:project_id) { 41 }
      let(:project) do
        {
          type: 'animals',
          status: 'Tree',
          bid_id: 'HIF/MV/1',
          data: {
            animal_noises: [{ ducks_go: 'quack' }, { cows_go: 'moo' }]
          },
          schema: { dogs: 'bark', cats: 'meow' },
          timestamp: '234'
        }
      end

      let(:find_project_spy) { spy(execute: project) }

      it 'should find the project with the given id' do
        expect(find_project_spy).to have_received(:execute).with(id: 41)
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should have project in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['type']).to eq('animals')
        expect(response_body['bid_id']).to eq('HIF/MV/1')
        expect(response_body['status']).to eq('Tree')
        expect(response_body['data']['animalNoises'][0]['ducksGo']).to eq('quack')
        expect(response_body['data']['animalNoises'][1]['cowsGo']).to eq('moo')
      end

      it 'should have a timestamp in body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['timestamp']).to eq('234')
      end

      it 'should have schema in the return body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['schema']['dogs']).to eq('bark')
        expect(response_body['schema']['cats']).to eq('meow')
      end
    end
  end
end
