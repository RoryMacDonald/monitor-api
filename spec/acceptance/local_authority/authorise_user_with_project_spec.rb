# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Authorises the user' do
  include_context 'dependency factory'

  before do
    ENV['PCS_SECRET'] = 'Woof'
    ENV['HMAC_SECRET'] = 'Meow'

    get_use_case(:add_user).execute(email: 'cat@cathouse.com', role: 'HomesEngland')
    get_use_case(:add_user_to_project).execute(project_id: 1, email: 'cat@cathouse.com')
  end

  after { get_gateway(:access_token).clear }

  context 'Correct access token for project' do
    it 'should create a valid access token for project 1' do
      access_token = get_use_case(:create_access_token).execute(email: 'cat@cathouse.com')[:access_token]

      expend_result = get_use_case(:expend_access_token).execute(access_token: access_token)
      expect(expend_result[:status]).to eq(:success)
      expect(expend_result[:role]).to eq('HomesEngland')
    end

    it 'should create a valid api key for project 1' do
      api_key = get_use_case(:create_api_key).execute(projects: [1], email: 'cat@cathouse.com', role: 'HomesEngland')[:api_key]
      expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: 1)).to eq(valid: true, email: 'cat@cathouse.com', role: 'HomesEngland')
    end

    it 'should create a valid pcs key for project 1' do
      api_key = api_key = get_use_case(:create_api_key).execute(projects: [1], email: 'cat@cathouse.com', role: 'Homes England')[:api_key]
      pcs_key = get_use_case(:api_to_pcs_key).execute(api_key: api_key)[:pcs_key]

      decoded_pcs_key = JWT.decode(
        pcs_key,
        'Woof',
        true,
        algorithm: 'HS512'
      )[0]
      expect(decoded_pcs_key['projects']).to eq([1])
      expect(decoded_pcs_key['email']).to eq('cat@cathouse.com')
      expect(decoded_pcs_key['role']).to eq('Homes England')
    end
  end

  context 'Incorrect project' do
    it 'Should have an incorrect apikey for the project' do
      api_key = get_use_case(:create_api_key).execute(projects: [1], email: 'cat@cathouse.com', role: 'HomesEngland')[:api_key]
      expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: 2)).to eq(valid: false)
    end
  end
end
