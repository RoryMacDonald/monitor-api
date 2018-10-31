# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Updating a project' do
  let(:update_project_spy) { spy(execute: { successful: true }) }
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
  end

  context 'with valid id and project' do
    before do
      post '/project/update', {
        project_id: project_id,
        project_data: new_project_data[:baselineData]
      }.to_json
    end

    it 'should return 200' do
      expect(last_response.status).to eq(200)
    end

    it 'should update project data for id' do
      expect(update_project_spy).to(
        have_received(:execute).with(
          id: project_id,
          data: { cats: 'quack', dogs: 'baa' }
        )
      )
    end
  end
end
