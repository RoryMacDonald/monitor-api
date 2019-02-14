describe LocalAuthority::UseCase::ApiToPcsKey do
  let(:use_case) { described_class.new }
  
  context 'returning a pcs api key' do
    it 'example 1' do
      ENV['HMAC_SECRET'] = 'Meow'
      ENV['PCS_SECRET'] = 'Woof'

      api_key = JWT.encode(
        {
          project_id: 1,
          exp: 2900000000,
          email: 'admin@airmail',
          role: 'Homes England'
        },
        'Meow',
        'HS512'
      )
      pcs_key = use_case.execute(api_key: api_key)[:pcs_key]
      decoded_pcs_key = JWT.decode(
        pcs_key,
        'Woof',
        true,
        algorithm: 'HS512'
      )[0]
      expect(decoded_pcs_key).to eq(
        {
          'project_id' => 1,
          'exp' => 2900000000,
          'email' => 'admin@airmail',
          'role' => 'Homes England'
        }
      )
    end

    it 'example 2' do
      ENV['HMAC_SECRET'] = 'Cheese'
      ENV['PCS_SECRET'] = 'Crackers'

      api_key = JWT.encode(
        {
          project_id: 1,
          exp: 2800000000,
          email: 'user@hotmail.cc',
          role: 'Local Authority'
        },
        'Cheese',
        'HS512'
      )
      pcs_key = use_case.execute(api_key: api_key)[:pcs_key]
      decoded_pcs_key = JWT.decode(
        pcs_key,
        'Crackers',
        true,
        algorithm: 'HS512'
      )[0]
      expect(decoded_pcs_key).to eq(
        {
          'project_id' => 1,
          'exp' => 2800000000,
          'email' => 'user@hotmail.cc',
          'role' => 'Local Authority'
        }
      )
    end
  end
end
