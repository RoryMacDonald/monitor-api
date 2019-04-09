# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Changing user role' do
  let(:project_id) do
    get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'cat sanctuary',
      baseline: nil,
      bid_id: '12345'
    )[:id]
  end
  include_context 'dependency factory'

  let(:env_before) { ENV }

  before do
    env_before
    ENV['PCS_SECRET'] = 'Woof'
    ENV['HMAC_SECRET'] = 'Meow'
  end

  after do
    ENV['PCS_SECRET'] = env_before['PCS_SECRET']
    ENV['HMAC_SECRET'] = env_before['HMAC_SECRET']
  end

  it 'make Homes England user a Superuser' do
    get_use_case(:add_user).execute(email: 'cat@cathouse.com', role: 'Homes England')
    get_use_case(:add_user_to_project).execute(project_id: project_id, email: 'cat@cathouse.com')
    get_use_case(:change_user_role).execute(email: 'cat@cathouse.com', role: 'Superuser')

    access_token = get_use_case(:create_access_token).execute(email: 'cat@cathouse.com')[:access_token]
    api_key = get_use_case(:expend_access_token).execute(access_token: access_token)[:api_key]

    expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: project_id)).to(
      eq(
        valid: true,
        email: 'cat@cathouse.com',
        role: 'Superuser'
      )
    )
  end
end
