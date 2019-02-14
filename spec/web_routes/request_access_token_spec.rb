# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'requesting an access token' do
  let(:notification_gateway_spy) { spy }
  let(:check_email_spy) { spy(execute: { valid: true }) }
  let(:send_notification_spy) { spy }
  let(:valid_email) { 'cats@meow.com' }
  let(:create_token_spy) { spy(execute: { access_token: 'Doggies' }) }

  before do
    stub_const(
      'LocalAuthority::UseCase::CheckEmail',
      double(new: check_email_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::InMemoryApiKeyGateway',
      double(new: nil)
    )

    stub_const(
      'LocalAuthority::UseCase::SendNotification',
      double(new: send_notification_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::GovEmailNotificationGateway',
      double(new: notification_gateway_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CreateAccessToken',
      double(new: create_token_spy)
    )
  end

  let(:project_id) { '1' }
  let(:url) { 'http://catscatscats.cat' }

  before do
    post '/token/request', { email_address: valid_email, url: url}.to_json
  end

  context 'Example one' do
    it 'checks email address' do
      expect(check_email_spy).to have_received(:execute).with(email_address: valid_email)
    end

    context 'given a valid email address' do
      it 'returns a 200' do
        expect(last_response.status).to eq(200)
      end

      it 'run the create access token use case' do
        expect(create_token_spy).to have_received(:execute).with(email: valid_email)
      end

      it 'passes email address and url to send notification use case' do
        expect(send_notification_spy).to have_received(:execute).with(to: valid_email, url: 'http://catscatscats.cat', access_token: 'Doggies')
      end
    end

    context 'given an invalid email address' do
      let(:check_email_spy) { spy(execute: { valid: false }) }

      before do
        post '/token/request', { email_address: 'not@valid.com', url: url }.to_json
      end

      it 'returns a 403' do
        expect(last_response.status)
          .to eq(403)
      end

      it 'does not pass email address and url to send notification use case' do
        expect(send_notification_spy).to_not have_received(:execute).with(to: valid_email, url: 'http://catscatscats.cat')
      end
    end
  end

  context 'Example two' do
    let(:url) { 'http://dogsdogsdogs.cat' }

    it 'checks email address' do
      expect(check_email_spy).to have_received(:execute).with(email_address: valid_email)
    end

    context 'given a valid email address' do
      it 'returns a 200' do
        expect(last_response.status).to eq(200)
      end

      it 'run the create access token use case' do
        expect(create_token_spy).to have_received(:execute).with(email: valid_email)
      end

      it 'passes email address and url to send notification use case' do
        expect(send_notification_spy).to have_received(:execute).with(to: valid_email, url: 'http://dogsdogsdogs.cat', access_token: 'Doggies')
      end
    end
  end
end
