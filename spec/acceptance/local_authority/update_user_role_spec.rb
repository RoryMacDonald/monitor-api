# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Updating the role of a user' do
  include_context 'dependency factory'

  let(:environment_before) { ENV }

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      type: 'hif',
      name: 'cat sanctuary',
      baseline: {},
      bid_id: '12345'
    )[:id]
  end

  let(:access_token) do
    get_use_case(:create_access_token).execute(email: 'cat@cathouse.com')[:access_token]
  end

  let(:api_key) do
    get_use_case(:expend_access_token).execute(access_token: access_token)[:api_key]
  end

  before do
    environment_before
    ENV['PCS_SECRET'] = 'Woof'
    ENV['HMAC_SECRET'] = 'Meow'
  end

  after do
    ENV['PCS_SECRET'] = environment_before['PCS_SECRET']
    ENV['HMAC_SECRET'] = environment_before['HMAC_SECRET']
  end

  def given_a_local_authority_user_is_added_to_a_project
    get_use_case(:add_user).execute(email: 'cat@cathouse.com', role: 'Local Authority')
    get_use_case(:add_user_to_project).execute(project_id: project_id, email: 'cat@cathouse.com')
  end

  def when_i_change_their_role_to_superuser
    get_use_case(:change_user_role).execute(email: 'cat@cathouse.com', role: 'Superuser')
    access_token
    api_key
  end

  def then_the_users_api_key_contains_the_role_superuser
    expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: project_id)).to(
      eq(
        valid: true,
        email: 'cat@cathouse.com',
        role: 'Superuser'
      )
    )
  end

  it 'Updates a Local Authority user to be a Superuser' do
    given_a_local_authority_user_is_added_to_a_project
    when_i_change_their_role_to_superuser
    then_the_users_api_key_contains_the_role_superuser
  end
end
