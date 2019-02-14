# frozen_string_literal: true

describe LocalAuthority::UseCase::ExpendAccessToken do
  let(:access_token) { '' }
  let(:email) { '' }

  let(:access_token_gateway_spy) do
    spy(
      find_by: LocalAuthority::Domain::AccessToken.new.tap do |token|
        token.uuid = access_token
        token.projects = projects
        token.email = email
        token.role = role
      end
    )
  end

  let(:use_case) do
    described_class.new(access_token_gateway: access_token_gateway_spy,
                        create_api_key: create_api_key_spy)
  end

  context 'given existing Access Tokens' do
    context 'example one' do
      let(:create_api_key_spy) { spy(execute: { api_key: 'Doggos' }) }
      let(:projects) { [0, 2] }
      let(:email) { 'dogs@dog.com' }
      let(:access_token) { '65d60eb7-18c8-4e32-abf0-1288eb8acc63' }
      let(:role) { 'LocalAuthority' }

      it 'should run the create api use case' do
        use_case.execute(access_token: access_token)
        expect(create_api_key_spy).to have_received(:execute).with(projects: [0, 2], email: 'dogs@dog.com', role: 'LocalAuthority')
      end

      it 'searches for the Access Token' do
        use_case.execute(access_token: access_token)
        expect(access_token_gateway_spy).to have_received(:find_by).with(uuid: access_token)
      end

      it 'removes the Access Token' do
        use_case.execute(access_token: access_token)
        expect(access_token_gateway_spy).to have_received(:delete).with(uuid: access_token)
      end

      context 'with a valid access token' do
        it 'return success' do
          expect(use_case.execute(access_token: access_token)).to eq(status: :success, api_key: 'Doggos', role: 'LocalAuthority')
        end
      end

      context 'when the token is invalid' do
        let(:access_token_gateway_spy) { spy(find_by: nil) }
        it 'return failure' do
          expect(use_case.execute(access_token: access_token)).to eq(status: :failure, api_key: '')
        end
      end
    end

    context 'example two' do
      let(:create_api_key_spy) { spy(execute: { api_key: 'Cats' }) }
      let(:email) { 'cats@cat.com' }
      let(:access_token) { 'a4156994-c490-4653-96cd-bf063acec758' }
      let(:projects) { [5] }
      let(:role) { 'HomesEngland' }

      it 'should run the create api use case' do
        use_case.execute(access_token: access_token)
        expect(create_api_key_spy).to have_received(:execute).with(projects: [5], email: 'cats@cat.com', role: 'HomesEngland')
      end

      it 'searches for the Access Token' do
        use_case.execute(access_token: access_token)
        expect(access_token_gateway_spy).to have_received(:find_by).with(uuid: access_token)
      end

      it 'removes the Access Token' do
        use_case.execute(access_token: access_token)
        expect(access_token_gateway_spy).to have_received(:delete).with(uuid: access_token)
      end

      context 'with a valid access token' do
        it 'return success' do
          expect(use_case.execute(access_token: access_token)).to eq(status: :success, api_key: 'Cats', role: 'HomesEngland')
        end
      end
    end
  end
end
