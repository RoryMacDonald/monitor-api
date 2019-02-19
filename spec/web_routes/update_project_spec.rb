# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Updating a project' do
  let(:get_project_spy) { spy(execute: { type: 'hif' })}
  let(:update_project_spy) { spy(execute: { successful: true, errors: [], timestamp: 6 }) }
  let(:create_new_project_spy) { spy(execute: project_id) }
  let(:project_id) { 1 }

  let(:existing_project_data) do
    {
      name: 'cat project',
      type: 'hif',
      baselineData: {
        cats: 'meow',
        dogs: 'woof'
      }
    }
  end

  let(:new_project_data) do
    {
      baselineData: {
        cats: 'quack',
        dogs: 'baa'
      }
    }
  end

  before do
    stub_const(
      'UI::UseCase::GetProject',
      double(new: get_project_spy)
    )

    stub_const(
      'UI::UseCase::UpdateProject',
      double(new: update_project_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: {valid: true}))
    )

    header 'API_KEY', 'superSecret'
  end

  context 'with invalid' do
    context 'id' do
      it 'should return 400' do
        post '/project/update',
             { project_id: nil,
               project_data: nil }.to_json
        expect(last_response.status).to eq(400)
      end
    end

    context 'project' do
      context 'which is nil' do
        it 'should return 400' do
          post '/project/update', { project_id: project_id, project_data: nil }.to_json

          expect(last_response.status).to eq(400)
        end
      end
    end

    context 'timestamp' do
      let(:update_project_spy) { spy(execute: { successful: true, errors: :incorrect_timestamp, timestamp: 6 }) }
      it 'should return error message and 200' do
        post '/project/update', { project_id: project_id, project_data: {data: 'some'}, timestamp: '1'}.to_json
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )

        expect(last_response.status).to eq(200)
        expect(response).to eq(errors: "incorrect_timestamp", timestamp: 6)
      end
    end
  end

  context 'with valid id and project' do
    before do
      post '/project/update', {
        project_id: project_id,
        project_type: 'hif',
        project_data: new_project_data[:baselineData],
        timestamp: '67'
      }.to_json
    end

    it 'should return 200' do
      expect(last_response.status).to eq(200)
    end

    it 'Should get the project for the id' do
      expect(get_project_spy).to(
        have_received(:execute).with(id: project_id, pcs_key: "superSecret")
      )
    end

    it 'should update project data for id' do
      expect(update_project_spy).to(
        have_received(:execute).with(
          id: project_id,
          type: 'hif',
          data: { cats: 'quack', dogs: 'baa' },
          timestamp: 67
        )
      )
    end
  end
end
