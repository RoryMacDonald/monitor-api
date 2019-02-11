describe LocalAuthority::UseCase::CheckApiKey do
  let(:use_case) { described_class.new }

  def one_hour_in_seconds
    3600
  end

  def api_key_for_project(projects, email, role, api_key=ENV['HMAC_SECRET'])
    one_hour_from_now = (Time.now.to_i + one_hour_in_seconds)
    JWT.encode({projects: projects, email: email, exp: one_hour_from_now, role: role}, api_key, 'HS512')
  end

  context 'Example one' do
    before { ENV['HMAC_SECRET'] = 'Cats' }

    context 'Given an invalid api key' do
      context 'That is not a JWT token' do
        it 'Returns invalid' do
          response = use_case.execute(api_key: 'cats', project_id: 1)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          response = use_case.execute(api_key: 'cats', project_id: 1)
          expect(response[:email]).to eq(nil)
        end

        it 'does not return a role' do
          response = use_case.execute(api_key: 'cats', project_id: 1)
          expect(response[:email]).to eq(nil)
        end
      end

      context 'That is signed by a different key' do
        it 'returns invalid' do
          api_key = api_key_for_project(1, 'dog@doghause.com', 'HomesEngland', 'dogs')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_project(1, 'dog@doghause.com', 'HomesEngland', 'dogs')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:email]).to eq(nil)
        end

        it 'does not return a role' do
          api_key = api_key_for_project(1, 'dog@doghause.com', 'HomesEngland', 'dogs')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:email]).to eq(nil)
        end
      end

      context 'That is expired' do
        it 'returns invalid' do
          api_key = JWT.encode(
            {
              project_id: 1, exp: Time.new(2010, 01, 01).to_i
            },
            ENV['HMAC_SECRET'],
            'HS512'
          )

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = JWT.encode(
            {
              project_id: 1, exp: Time.new(2010, 01, 01).to_i
            },
            ENV['HMAC_SECRET'],
            'HS512'
          )

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:email]).to eq(nil)
        end
      end
    end

    context 'given a valid api key' do
      context 'For a different project' do
        it 'Returns invalid' do
          api_key = api_key_for_project([1], 'cat@cathouse.com', 'LocalAuthority')

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_project([1], 'cat@cathouse.com', 'LocalAuthority')

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:email]).to eq(nil)
        end
      end

      context 'For the correct project' do
        it 'Returns valid' do
          api_key = api_key_for_project([1], 'cat@cathouse.com', 'LocalAuthority')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(true)
        end

        it 'returns an email' do
          api_key = api_key_for_project([1], 'cat@cathouse.com', 'LocalAuthority')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:email]).to eq('cat@cathouse.com')
        end

        it 'returns a role' do
          api_key = api_key_for_project([1], 'cat@cathouse.com', 'LocalAuthority')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:role]).to eq('LocalAuthority')
        end
      end
    end
  end

  context 'Example two' do
    before { ENV['HMAC_SECRET'] = 'Dogs' }

    context 'Given an invalid api key' do
      context 'That is not a JWT token' do
        it 'Returns invalid' do
          response = use_case.execute(api_key: 'dogs', project_id: 5)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          response = use_case.execute(api_key: 'dogs', project_id: 1)
          expect(response[:email]).to eq(nil)
        end
      end

      context 'That is signed by a different key' do
        it 'returns invalid' do
          api_key = api_key_for_project([5], 'cats@meow.com', 's151', 'meow')

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_project([6], 'cats@meow.com', 's151', 'meow')

          response = use_case.execute(api_key: 'dogs', project_id: 1)
          expect(response[:email]).to eq(nil)
        end
      end
    end

    context 'given a valid api key' do
      context 'For a different project' do
        it 'Returns invalid' do
          api_key = api_key_for_project([5], 'cats@ny.an', 's151')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(false)
        end

        it 'does not return an email' do
          api_key = api_key_for_project([6], 'cats@meow.com', 's151', 'meow')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:email]).to eq(nil)
        end

        it 'returns a role' do
          api_key = api_key_for_project([6], 'cats@meow.com', 's151')

          response = use_case.execute(api_key: api_key, project_id: 6)
          expect(response[:role]).to eq('s151')
        end
      end

      context 'For the correct project' do
        it 'Returns valid' do
          api_key = api_key_for_project([5], 'cats@ny.an', 's151')

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:valid]).to eq(true)
        end

        it 'returns an email' do
          api_key = api_key_for_project([5], 'cats@meow.com', 's151')

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:email]).to eq('cats@meow.com')
        end
      end
    end
  end
end
