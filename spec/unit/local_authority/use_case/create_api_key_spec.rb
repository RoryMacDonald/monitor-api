require 'date'
require 'timecop'

describe LocalAuthority::UseCase::CreateApiKey do
  let(:use_case) { described_class.new }
  let(:thirty_days_in_seconds) { 60 * 60 * 24 * 30 }

  context 'Example one' do
    before do
      ENV['HMAC_SECRET'] = 'cats'
    end

    it 'Returns an API key' do
      expect(use_case.execute(projects: [1], email: 'cat@cathouse.com', role: 'LocalAuthority')[:api_key]).not_to be_nil
    end

    it 'Stores the project id and email within the api key' do
      api_key = use_case.execute(projects: [1], email: 'cat@cathouse.com', role: 'HomesEngland')[:api_key]

      decoded_key = JWT.decode(
        api_key,
        'cats',
        true,
        algorithm: 'HS512'
      )

      expect(decoded_key[0]['projects']).to eq([1])
      expect(decoded_key[0]['email']).to eq('cat@cathouse.com')
      expect(decoded_key[0]['role']).to eq('HomesEngland')
    end

    it 'Sets the expiry to 30 days away' do
      now = DateTime.now + 1
      Timecop.freeze(now)
      api_key = use_case.execute(projects: [1], email: 'cat@cathouse.com', role: 'LocalAuthority')[:api_key]
      Timecop.return


      decoded_key = JWT.decode(
        api_key,
        'cats',
        true,
        algorithm: 'HS512'
      )

      expected_time = now.strftime("%s").to_i + thirty_days_in_seconds

      expect(decoded_key[0]['exp']).to eq(expected_time)
    end
  end

  context 'Example two' do
    before do
      ENV['HMAC_SECRET'] = 'dogs'
    end

    it 'Returns an API key' do
      expect(use_case.execute(projects: [5], email: 'dog@doghaus.com', role: 'LocalAuthority')[:api_key]).not_to be_nil
    end

    it 'Stores the project id, role and email within the api key' do
      api_key = use_case.execute(projects: [5], email: 'dog@doghaus.com', role: 'LocalAuthority')[:api_key]

      decoded_key = JWT.decode(
        api_key,
        'dogs',
        true,
        algorithm: 'HS512'
      )

      expect(decoded_key[0]['projects']).to eq([5])
      expect(decoded_key[0]['email']).to eq('dog@doghaus.com')
      expect(decoded_key[0]['role']).to eq('LocalAuthority')
    end

    it 'Sets the expiry to 30 days away' do
      now = DateTime.now + 3
      Timecop.freeze(now)
      api_key = use_case.execute(projects: [1], email: 'dog@doghaus.com', role: 'LocalAuthority')[:api_key]
      Timecop.return


      decoded_key = JWT.decode(
        api_key,
        'dogs',
        true,
        algorithm: 'HS512'
      )

      expected_time = now.strftime("%s").to_i + thirty_days_in_seconds

      expect(decoded_key[0]['exp']).to eq(expected_time)
    end
  end
end
