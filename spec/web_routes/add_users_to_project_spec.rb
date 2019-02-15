# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Adding users to a project' do
  ENV['HTTP_API_KEY'] = 'supersecret'

  def set_correct_auth_header
    header 'API_KEY', ENV['HTTP_API_KEY']
  end

  def set_incorrect_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY'] + 'make_key_invalid'
  end

  context 'when no authorization provided in a header' do
    let(:body) { { users: [{ email: 'person1@mt.com' }] } }

    it 'returns 400' do
      post('project/1/add_users', body.to_json)
      expect(last_response.status).to eq(400)
    end
  end
  
  context 'when correct authorization provided' do
    before do
      stub_const(
        'LocalAuthority::UseCase::CheckApiKey',
        double(new: double(execute: {valid: true}))
        )
        
      set_correct_auth_header
    end

    context 'when request body is invalid' do
      context 'does not have users key' do
        let(:invalid_body) { { invalid_key: [{ email: 'person1@mt.com' }] } }

        it 'returns 400' do
          post('project/1/add_users', invalid_body.to_json)
          expect(last_response.status).to eq(400)
        end
      end

      context 'users key is not an array' do
        let(:invalid_body) { { users: 'person1@mt.com' } }

        it 'returns 400' do
          post('project/1/add_users', invalid_body.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end
    context 'when request body is valid' do
      let(:add_user_to_project_usecase_spy) { spy }
      let(:valid_request_body) { { users: [{ email: 'mt@mt.com' }] } }

      before do
        stub_const(
          'HomesEngland::UseCase::AddUserToProject',
          double(new: add_user_to_project_usecase_spy)
        )
      end

      it 'returns 200' do
        post('project/1/add_users', valid_request_body.to_json)
        expect(last_response.status).to eq(200)
      end

      context 'users array has no entries' do
        let(:body) { { users: [] } }

        it 'returns 200' do
          post('project/1/add_users', body.to_json)
          expect(last_response.status).to eq(200)
        end
      end

      context 'it adds a single user' do
        example 'example 1' do
          request_body = { users: [{ email: 'mt1@mt1.com', role: 'S151' }] }
          post('project/33/add_users', request_body.to_json)
          expect(add_user_to_project_usecase_spy).to have_received(:execute).with(
            project_id: 33,
            role: 'S151',
            email: 'mt1@mt1.com'
          )
        end

        example 'example 2' do
          request_body = { users: [{ email: 'cat@mouse.com' }] }
          post('project/24/add_users', request_body.to_json)
          expect(add_user_to_project_usecase_spy).to have_received(:execute).with(
            project_id: 24,
            role: nil,
            email: 'cat@mouse.com'
          )
        end
      end

      context 'when each entry in the body is non-empty' do
        let(:request_body) { { users: [{ email: 'mt1@mt1.com', role: 'Homes England' }, { email: 'mt2@mt2.com', role: 'Local Authority' }] } }

        it 'execute AddUserToProject use case for each valid email' do
          post('project/33/add_users', request_body.to_json)
          expect(add_user_to_project_usecase_spy).to have_received(:execute).with(
            project_id: 33,
            role: 'Homes England',
            email: 'mt1@mt1.com'
          )
          expect(add_user_to_project_usecase_spy).to have_received(:execute).with(
            project_id: 33,
            role: 'Local Authority',
            email: 'mt2@mt2.com'
          )
        end
      end
    end
  end
end
