# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Creating a new project' do
  let(:create_new_project_spy) { spy(execute: project_id) }
  let(:setup_auth_headers) { set_correct_auth_header }

  ENV['ADMIN_HTTP_API_KEY'] = 'verysecretkey'

  def set_correct_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY']
  end

  def set_incorrect_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY'] + 'make_key_invalid'
  end

  before do
    setup_auth_headers

    stub_const(
      'UI::UseCase::CreateProject',
      double(new: create_new_project_spy)
    )

    post('/project/create', project_data.to_json)
  end

  context 'when incorrect authentication was supplied' do
    let(:setup_auth_headers) { set_incorrect_auth_header }
    let(:project_id) { 1 }
    let(:project_data) do
      {
        name: 'Dog project',
        type: 'hif',
        baselineData: {
          cats: 'meow',
          dogs: 'woof'
        }
      }
    end

    it 'returns 401' do
      expect(last_response.status).to eq(401)
    end
  end

  context 'with no project name supplied' do
    let(:project_id) { 1 }
    let(:project_data) do
      {
        type: 'hif',
        baselineData: {
          cats: 'Woof',
          dogs: 'Meow'
        }
      }
    end

    it 'returns 400' do
      expect(last_response.status).to eq(400)
    end
  end

  context 'example one' do
    let(:project_id) { 1 }
    let(:project_data) do
      {
        name: 'Dog project',
        type: 'hif',
        bid_id: 'HIF/MV/155',
        baselineData: {
          cats: 'meow',
          dogs: 'woof'
        }
      }
    end

    it 'should call the create_new_project use case' do
      expect(create_new_project_spy).to have_received(:execute)
    end

    it 'should call the create_new_project use case with name' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(name: 'Dog project')
        )
      )
    end

    it 'should call the create_new_project use case with bid_id' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(bid_id: 'HIF/MV/155')
        )
      )
    end

    it 'should call the create_new_project use case with type' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(type: 'hif')
        )
      )
    end

    it 'should create new project with baseline data' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(baseline: { cats: 'meow', dogs: 'woof' })
        )
      )
    end

    it 'should return the id of the project' do
      response_body = JSON.parse(last_response.body)

      expect(response_body['projectId']).to eq(project_id)
    end
  end

  context 'example two' do
    let(:project_id) { 42 }
    let(:project_data) do
      {
        name: 'Duck project',
        type: 'ac',
        bid_id: 'AC/MV/111',
        baselineData: {
          ducks: 'quack',
          good: [
            {
              dogs: 'yes',
              wasps: 'no'
            }
          ]
        }
      }
    end

    it 'should call the create_new_project use case with name' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(name: 'Duck project')
        )
      )
    end

    it 'should call the create_new_project use case with bid_id' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(bid_id: 'AC/MV/111')
        )
      )
    end

    it 'should return a 201 response' do
      expect(last_response.status).to eq(201)
    end

    it 'should call the create_new_project use case' do
      expect(create_new_project_spy).to have_received(:execute)
    end

    it 'should call the create_new_project use case with type' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(type: 'ac')
        )
      )
    end

    it 'should create new project with baseline data' do
      expected_baseline = {
        ducks: 'quack',
        good: [
          {
            dogs: 'yes',
            wasps: 'no'
          }
        ]
      }
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(baseline: expected_baseline)
        )
      )
    end

    it 'should return the id of the project' do
      response_body = JSON.parse(last_response.body)

      expect(response_body['projectId']).to eq(project_id)
    end
  end
end
