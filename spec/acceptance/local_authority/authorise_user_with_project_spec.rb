# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Authorises the user' do
  include_context 'dependency factory'

  before do
    environment_before
    ENV['PCS_SECRET'] = 'Woof'
    ENV['HMAC_SECRET'] = 'Meow'
    given_a_user
  end

  after do
    get_gateway(:access_token).clear
    ENV['PCS_SECRET'] = environment_before['PCS_SECRET']
    ENV['HMAC_SECRET'] = environment_before['HMAC_SECRET']
  end

  let(:project_id) do
    get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'cat sanctuary',
      baseline: nil,
      bid_id: '12345'
    )[:id]
  end

  let(:environment_before) { ENV }

  let(:access_token) { get_use_case(:create_access_token).execute(email: 'cat@cathouse.com')[:access_token] }
  let(:expend_result) { get_use_case(:expend_access_token).execute(access_token: access_token) }
  let(:apikey) do
    access_token
    expend_result
  end

  def given_a_user
    get_use_case(:add_user).execute(email: 'cat@cathouse.com', role: 'Homes England')
    get_use_case(:add_user_to_project).execute(project_id: project_id, email: 'cat@cathouse.com')
  end

  def given_an_apikey_from_expend
    apikey
  end

  context 'User has access to the project' do
    context do
      def given_an_access_token_for_the_user
        access_token
      end

      def when_the_access_token_is_expended
        expend_result
      end

      def then_it_provides_a_role_and_status
        expect(expend_result[:status]).to eq(:success)
        expect(expend_result[:role]).to eq('Homes England')
      end

      it 'should create a valid access token' do
        given_an_access_token_for_the_user
        when_the_access_token_is_expended
        then_it_provides_a_role_and_status
      end
    end

    context do
      let(:api_key_check) do
        get_use_case(:check_api_key)
          .execute(api_key: expend_result[:api_key], project_id: project_id)
      end

      def when_checking_the_key_against_an_authorised_project
        api_key_check
      end

      def given_an_api_key_for_the_project
        apikey
      end

      def then_the_project_can_be_accessed
        expect(
          api_key_check
        ).to eq(valid: true, email: 'cat@cathouse.com', role: 'Homes England')
      end

      it 'And is able to login to project' do
        given_an_apikey_from_expend
        when_checking_the_key_against_an_authorised_project
        then_the_project_can_be_accessed
      end
    end
  end

  context 'User does not have access to project' do
    let(:api_key_check) do
      get_use_case(:check_api_key)
        .execute(api_key: expend_result[:api_key], project_id: project_id+1)
    end

    def when_checking_the_key_against_an_unauthorised_project
      api_key_check
    end

    def then_the_project_cannot_be_accessed
      expect(
        api_key_check
      ).to eq(valid: false)
    end

    it 'And is not able to login to project' do
      given_an_apikey_from_expend
      when_checking_the_key_against_an_unauthorised_project
      then_the_project_cannot_be_accessed
    end
  end
end
