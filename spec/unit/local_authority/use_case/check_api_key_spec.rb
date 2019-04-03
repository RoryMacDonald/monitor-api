describe LocalAuthority::UseCase::CheckApiKey do
  let(:user_projects) { { project_list: [] } }
  let(:get_user_projects_stub) { double(execute: user_projects) }
  let(:user_gateway_spy) {nil}
  let(:use_case) do
    described_class.new(get_user_projects: get_user_projects_stub, user_gateway: user_gateway_spy)
  end

  def one_hour_in_seconds
    3600
  end

  def api_key_for_user(email, api_key = ENV['HMAC_SECRET'])
    one_hour_from_now = (Time.now.to_i + one_hour_in_seconds)
    JWT.encode({ email: email, exp: one_hour_from_now }, api_key, 'HS512')
  end

  context 'Example one' do
    before { ENV['HMAC_SECRET'] = 'Cats' }

    context 'Given an invalid api key' do
      context 'That is not a JWT token' do
        it 'Returns invalid' do
          response = use_case.execute(api_key: 'cats', project_id: '1')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          response = use_case.execute(api_key: 'cats', project_id: '1')
          expect(response[:email]).to eq(nil)
        end

        it 'does not return a role' do
          response = use_case.execute(api_key: 'cats', project_id: '1')
          expect(response[:email]).to eq(nil)
        end
      end

      context 'That is signed by a different key' do
        it 'returns invalid' do
          api_key = api_key_for_user('dog@doghause.com', 'dogs')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_user('dog@doghause.com', 'dogs')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:email]).to eq(nil)
        end

        it 'does not return a role' do
          api_key = api_key_for_user('dog@doghause.com', 'dogs')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:email]).to eq(nil)
        end
      end

      context 'That is expired' do
        it 'returns invalid' do
          api_key = JWT.encode(
            {
              exp: Time.new(2010, 1, 1).to_i
            },
            ENV['HMAC_SECRET'],
            'HS512'
          )

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = JWT.encode(
            {
              exp: Time.new(2010, 01, 01).to_i
            },
            ENV['HMAC_SECRET'],
            'HS512'
          )

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:email]).to eq(nil)
        end
      end
    end

    context 'given a valid api key' do
      let(:user_gateway_spy) do
        spy(find_by:
          LocalAuthority::Domain::User.new.tap do |u|
            u.email = 'cat@cathouse.com'
            u.role = 'Local Authority'
          end
        )
      end

      context 'And the user is not on the project' do
        let(:user_projects) { { project_list: [{ id: 1 }] } }

        it 'Returns invalid' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(response[:email]).to eq(nil)
        end
      end

      context 'For the correct project' do
        let(:user_projects) { { project_list: [{ id: 1 }] } }

        it 'Returns valid' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:valid]).to eq(true)
        end

        it 'returns an email' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:email]).to eq('cat@cathouse.com')
        end

        it 'calls the user gateway' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(user_gateway_spy).to have_received(:find_by).with(email: 'cat@cathouse.com')
        end

        it 'returns a role' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:role]).to eq('Local Authority')
        end
      end

      context 'for no project' do
        it 'returns valid' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(response[:valid]).to eq(true)
        end

        it 'returns an email' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(response[:email]).to eq('cat@cathouse.com')
        end

        it 'calls the user gateway' do
          api_key = api_key_for_user('cat@cathouse.com')
          response = use_case.execute(api_key: api_key, project_id: nil)

          expect(user_gateway_spy).to have_received(:find_by).with(email: 'cat@cathouse.com')
        end

        it 'returns a role' do
          api_key = api_key_for_user('cat@cathouse.com')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(response[:role]).to eq('Local Authority')
        end
      end
    end
  end

  context 'Example two' do
    before { ENV['HMAC_SECRET'] = 'Dogs' }

    context 'Given an invalid api key' do
      context 'That is not a JWT token' do
        it 'Returns invalid' do
          response = use_case.execute(api_key: 'dogs', project_id: '5')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          response = use_case.execute(api_key: 'dogs', project_id: '1')
          expect(response[:email]).to eq(nil)
        end
      end

      context 'That is signed by a different key' do
        it 'returns invalid' do
          api_key = api_key_for_user('cats@meow.com', 'meow')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key_for_user('cats@meow.com', 'meow')

          response = use_case.execute(api_key: 'dogs', project_id: '1')
          expect(response[:email]).to eq(nil)
        end
      end
    end

    context 'given a valid api key' do
      let(:user_gateway_spy) do
        spy(find_by:
          LocalAuthority::Domain::User.new.tap do |u|
            u.email = 'cats@ny.an'
            u.role = 's151'
          end
        )
      end

      context 'For a different project' do
        let(:user_projects) { { project_list: [{ id: 3 }, { id: 4 }, { id: 5 }] } }

        it 'Returns invalid' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_user('cats@meow.com', 'meow')

          response = use_case.execute(api_key: api_key, project_id: '1')
          expect(response[:email]).to eq(nil)
        end

      end

      context 'For the correct project' do
        let(:user_projects) { { project_list: [{ id: 3 }, { id: 4 }, { id: 5 }] } }

        it 'Returns valid' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(response[:valid]).to eq(true)
        end

        it 'returns an email' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(response[:email]).to eq('cats@ny.an')
        end

        it 'returns a role' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(response[:role]).to eq('s151')
        end

        it 'calls the user gateway' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: '5')
          expect(user_gateway_spy).to have_received(:find_by).with(email: 'cats@ny.an')
        end
      end

      context 'for no project' do
        it 'returns valid' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(response[:valid]).to eq(true)
        end

        it 'returns an email' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(response[:email]).to eq('cats@ny.an')
        end

        it 'calls the user gateway' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(user_gateway_spy).to have_received(:find_by).with(email: 'cats@ny.an')
        end

        it 'returns a role' do
          api_key = api_key_for_user('cats@ny.an')

          response = use_case.execute(api_key: api_key, project_id: nil)
          expect(response[:role]).to eq('s151')
        end
      end
    end

  end
end
