# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Admin changing user role' do
  let(:env_before) { ENV }

  before do
    env_before
    ENV['ADMIN_HTTP_API_KEY'] = 'supersecret'
  end

  after do
    ENV['ADMIN_HTTP_API_KEY'] = env_before['ADMIN_HTTP_API_KEY']
  end

  def set_correct_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY']
  end

  def set_incorrect_auth_header
    header 'API_KEY', ENV['ADMIN_HTTP_API_KEY'] + 'make_key_invalid'
  end

  context 'when no authorization provided in a header' do
    let(:body) { { users: [{ email: 'person1@mt.com' }] } }

    it 'returns 401' do
      post('/admin/user/role', body.to_json)
      expect(last_response.status).to eq(401)
    end
  end

  context 'when correct authorization provided' do
    before do
      stub_instances(
        LocalAuthority::UseCase::CheckApiKey,
        double(execute: {valid: true})
      )

      set_correct_auth_header
    end

    context 'when request body is invalid' do
      context 'missing a role' do
        let(:invalid_body) { { email: 'super@user.cc' } }

        it 'returns 400' do
          post('/admin/user/role', invalid_body.to_json)
          expect(last_response.status).to eq(400)
        end
      end

      context 'missing a user' do
        let(:invalid_body) { { role: 'Superuser' } }

        it 'returns 400' do
          post('/admin/user/role', invalid_body.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end

    context 'when request body is valid' do
      let(:change_user_role_spy) { spy }
      let(:valid_request_body) { { email: 'super@user.cc', role: 'Superuser' } }

      before do
        stub_instances(
          HomesEngland::UseCase::ChangeUserRole,
          change_user_role_spy
        )
      end

      it 'returns 200' do
        post('/admin/user/role', valid_request_body.to_json)
        expect(last_response.status).to eq(200)
      end

      context 'it changes the role of a user' do
        example 'example 1' do
          request_body = { email: 'my@mail.com', role: 'Homes England' }
          post('/admin/user/role', request_body.to_json)
          expect(change_user_role_spy).to have_received(:execute).with(
            email: 'my@mail.com',
            role: 'Homes England'
          )
        end

        example 'example 2' do
          request_body = { email: 'user@me.com', role: 'Local Authority' }
          post('/admin/user/role', request_body.to_json)
          expect(change_user_role_spy).to have_received(:execute).with(
            email: 'user@me.com',
            role: 'Local Authority'
          )
        end
      end
    end
  end
end
