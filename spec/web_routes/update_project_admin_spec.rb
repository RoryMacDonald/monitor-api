# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Updating a projects baseline data' do
  context 'Example 1' do
    let(:check_api_key_spy) { double(execute: { valid: true }) }
    let(:update_project_admin_spy) { spy(execute: { successful: true, errors: [], timestamp: 6 }) }
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
        admin_data: {
          cats: 'quack',
          dogs: 'baa'
        }
      }
    end

    before do
      stub_instances(HomesEngland::UseCase::UpdateProjectAdmin, update_project_admin_spy)
      stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)

      header 'API_KEY', 'superSecret'
    end

    context 'with invalid' do
      context 'id' do
        it 'should return 400' do
          post '/project/admin/update',
               { project_id: nil,
                 project_data: nil }.to_json
          expect(last_response.status).to eq(400)
        end
      end

      context 'project' do
        context 'which is nil' do
          it 'should return 400' do
            post '/project/admin/update', { project_id: project_id, data: nil }.to_json

            expect(last_response.status).to eq(400)
          end
        end
      end

      context 'timestamp' do
        let(:update_project_admin_spy) { spy(execute: { successful: true, errors: :incorrect_timestamp, timestamp: 6 }) }
        it 'should return error message and 200' do
          post '/project/admin/update', { project_id: project_id, project_data: { data: 'some' }, timestamp: '1' }.to_json
          response = Common::DeepSymbolizeKeys.to_symbolized_hash(
            JSON.parse(last_response.body)
          )

          expect(last_response.status).to eq(200)
          expect(response).to eq(errors: 'incorrect_timestamp', timestamp: 6)
        end
      end
    end

    context 'with valid id and project' do
      before do
        post '/project/admin/update', {
          project_id: project_id,
          project_data: new_project_data[:admin_data],
          timestamp: '67'
        }.to_json
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should update project data' do
        expect(update_project_admin_spy).to(
          have_received(:execute).with(
            project_id: project_id,
            data: { cats: 'quack', dogs: 'baa' },
            timestamp: 67
          )
        )
      end

      it 'should check the validity of the api key' do
        expect(check_api_key_spy).to(
          have_received(:execute).with(
            project_id: project_id,
            api_key: 'superSecret'
          )
        )
      end
    end
  end

  context 'Example 2' do
    let(:check_api_key_spy) { double(execute: { valid: true }) }
    let(:update_project_admin_spy) { spy(execute: { successful: true, errors: [], timestamp: 7 }) }
    let(:project_id) { 2 }

    let(:existing_project_data) do
      {
        name: 'dog project',
        type: 'ac',
        admin_data: {
          cats: 'purr',
          dogs: 'bark'
        }
      }
    end

    let(:new_project_data) do
      {
        admin_data: {
          cats: 'moo',
          dogs: 'quack'
        }
      }
    end

    before do
      stub_instances(HomesEngland::UseCase::UpdateProjectAdmin, update_project_admin_spy)
      stub_instances(LocalAuthority::UseCase::CheckApiKey, check_api_key_spy)

      header 'API_KEY', 'verySecret'
    end

    context 'with invalid' do
      context 'id' do
        it 'should return 400' do
          post '/project/admin/update',
               { project_id: nil,
                 project_data: nil }.to_json
          expect(last_response.status).to eq(400)
        end
      end

      context 'project' do
        context 'which is nil' do
          it 'should return 400' do
            post '/project/admin/update', { project_id: project_id, project_data: nil }.to_json

            expect(last_response.status).to eq(400)
          end
        end
      end

      context 'timestamp' do
        let(:update_project_admin_spy) { spy(execute: { successful: true, errors: :incorrect_timestamp, timestamp: 6 }) }
        it 'should return error message and 200' do
          post '/project/admin/update', { project_id: project_id, project_data: { data: 'some' }, timestamp: '1' }.to_json
          response = Common::DeepSymbolizeKeys.to_symbolized_hash(
            JSON.parse(last_response.body)
          )

          expect(last_response.status).to eq(200)
          expect(response).to eq(errors: 'incorrect_timestamp', timestamp: 6)
        end
      end
    end

    context 'with valid id and project' do
      before do
        post '/project/admin/update', {
          project_id: project_id,
          project_data: new_project_data[:admin_data],
          timestamp: '67'
        }.to_json
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should update the project data' do
        expect(update_project_admin_spy).to(
          have_received(:execute).with(
            project_id: project_id,
            data: { cats: 'moo', dogs: 'quack' },
            timestamp: 67
          )
        )
      end

      it 'should check the validity of the api key' do
        expect(check_api_key_spy).to(
          have_received(:execute).with(
            project_id: project_id,
            api_key: 'verySecret'
          )
        )
      end
    end
  end
end
