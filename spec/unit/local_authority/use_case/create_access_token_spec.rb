# frozen_string_literal: true

describe LocalAuthority::UseCase::CreateAccessToken do
  let(:access_token_gateway_spy) { spy }
  let(:user_gateway_spy) {
    spy(
      find_by: LocalAuthority::Domain::User.new.tap do |u|
        u.id = 1
        u.email = email
        u.role = role
        u.projects = projects
      end
    )
  }
  let(:use_case) { described_class.new(access_token_gateway: access_token_gateway_spy, user_gateway: user_gateway_spy) }

  context 'with no stored users' do
    let(:user_gateway_spy) { spy(find_by: nil) }
    it 'returns failure' do
      result = use_case.execute(email: 'cat@cats.cat')
      expect(result[:status]).to eq(:failure)
      expect(result[:uuid]).to eq(nil)
    end
  end

  context 'with multiple stored users' do
    let(:user_gateway_spy) {
      Class.new do
        def initialize
          @users_to_return = [
            LocalAuthority::Domain::User.new.tap do |u|
              u.id = 1
              u.email = 'cat@cathouse.com'
              u.projects = [1, 2, 3]
              u.role = 'Homes England'
            end,
            LocalAuthority::Domain::User.new.tap do |u|
              u.id = 2
              u.projects = [2, 5, 7]
              u.email = 'dog@doghouse.com'
              u.role = 'Local Authority'
            end
          ]
        end

        def find_by(email:)
          @users_to_return.shift
        end
      end.new
    }
    it 'returns different access token' do
      expect(described_class.new(access_token_gateway: access_token_gateway_spy, user_gateway: user_gateway_spy).execute(email: 'cat@cathouse.com')).not_to(
        eq(described_class.new(access_token_gateway: access_token_gateway_spy, user_gateway: user_gateway_spy).execute(email: 'dog@doghouse.com')))
    end
  end

  context 'example 1' do
    let(:email) { 'dog@doghouse.com' }
    let(:role) { 'S151' }
    let(:projects) { [2, 5, 7]}

    it 'saves the access token to the gateway' do
      use_case.execute(email: 'dog@doghouse.com')
        expect(access_token_gateway_spy).to have_received(:create) do |arg|
          expect(arg.uuid.length).to eq(36)
          expect(arg.uuid.class).to eq(String)
          expect(arg.projects).to eq([2, 5, 7])
          expect(arg.email).to eq('dog@doghouse.com')
          expect(arg.role).to eq('S151')
        end
    end

    it 'should call the user gateway' do
      use_case.execute(email: 'dog@doghouse.com')

      expect(user_gateway_spy).to have_received(:find_by).with(email: 'dog@doghouse.com')
    end

    it 'should create an access token' do
      result = use_case.execute(email: 'dog@doghouse.com')
      expect(result[:access_token].length).to eq(36)
      expect(result[:access_token].class).to eq(String)
    end

    it 'should have the status success' do
      result = use_case.execute(email: 'dog@doghouse.com')
      expect(result[:status]).to eq(:success)
    end
  end

  context 'example 2' do
    let(:email) { 'cat@cathouse.com' }
    let(:role) { 'Local Authority' }
    let(:projects) { [1, 2, 3]}

    it 'saves the access token to the gateway' do
      use_case.execute(email: 'cat@cathouse.com')
      expect(access_token_gateway_spy).to have_received(:create) do |arg|
        expect(arg.uuid.length).to eq(36)
        expect(arg.uuid.class).to eq(String)
        expect(arg.projects).to eq([1, 2, 3])
        expect(arg.email).to eq('cat@cathouse.com')
        expect(arg.role).to eq('Local Authority')
      end
    end

    it 'should call the user gateway' do
      use_case.execute(email: 'cat@cathouse.com')

      expect(user_gateway_spy).to have_received(:find_by).with(email: 'cat@cathouse.com')
    end

    it 'should have the status success' do
      result = use_case.execute(email: 'cat@cathouse.com')
      expect(result[:status]).to eq(:success)
    end
  end
end
