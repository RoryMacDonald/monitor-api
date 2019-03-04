require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a claim' do
  let(:notify_project_members_of_submission_spy) { spy }
  let(:submit_claim_spy) { spy(execute: nil) }
  let(:check_api_key_spy) { spy(execute: { valid: true, email: email }) }
  let(:email) { '' }

  before do
    stub_instances(LocalAuthority::UseCase::SubmitClaimCore, submit_claim_spy)

    stub_instances(
      LocalAuthority::UseCase::NotifyProjectMembers,
      notify_project_members_of_submission_spy
    )

    stub_instances(
      LocalAuthority::UseCase::CheckApiKey,
      check_api_key_spy
    )
  end

  it 'submitting nothing should return 400' do
    post '/claim/submit', nil, 'HTTP_API_KEY' => 'superSecret'
    expect(last_response.status).to eq(400)
  end

  it 'submitting a valid id should return 200' do
    post '/claim/submit', { claim_id: '1', project_id: '1' }.to_json, 'HTTP_API_KEY' => 'superSecret'
    expect(last_response.status).to eq(200)
  end

  context 'example one' do
    let(:email) { 'cow@barn.net' }
    it 'will run submit return use case with id' do
      post '/claim/submit', { claim_id: '1', project_id: '1', url: 'placeholder.com' }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(submit_claim_spy).to have_received(:execute).with(claim_id: 1)
    end
  end

  context 'example two' do
    let(:email) { 'dog@kennel.co' }
    it 'will run submit return use case with id' do
      post '/claim/submit', { claim_id: '42', project_id: '1', url: 'example.net' }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(submit_claim_spy).to have_received(:execute).with(claim_id: 42)
    end
  end
end
