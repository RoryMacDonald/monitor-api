describe LocalAuthority::UseCase::GetClaims do
  let(:claims) { [] }
  let(:claim_gateway_spy) { spy(get_all: claims)}
  let(:usecase) do
    described_class.new(claims_gateway: claim_gateway_spy)
  end

  let(:response) { usecase.execute(project_id: project_id) }

  before { response }

  context 'Example 1' do
    let(:project_id) { 1 }
    let(:claims) do
      [
        LocalAuthority::Domain::Claim.new.tap do |claim|
          claim.id = 3
          claim.project_id = 1
          claim.type = 'hif'
          claim.status = 'Draft'
          claim.data = { cat: 'Meow' }
          claim.bid_id = 'HIF/MV/7834'
        end
      ]
    end

    it 'calls the claims gateway' do 
      expect(claim_gateway_spy).to have_received(:get_all).with(project_id: 1)
    end

    it 'returns an array including the claim' do
      expect(response[:claims].first).to eq(
        {
          id: 3,
          project_id: 1,
          type: 'hif',
          status: 'Draft',
          data: { cat: 'Meow' },
          bid_id: 'HIF/MV/7834'
        }
      )
    end
  end

  context 'Example 2' do
    let(:project_id) { 4 }
    let(:claims) do
      [
        LocalAuthority::Domain::Claim.new.tap do |claim|
          claim.id = 8
          claim.project_id = 4
          claim.type = 'ac'
          claim.status = 'Submitted'
          claim.data = { turkey: 'squark' }
          claim.bid_id = 'AC/GF/7834'
        end,
        LocalAuthority::Domain::Claim.new.tap do |claim|
          claim.id = 54
          claim.project_id = 3
          claim.type = 'blah'
          claim.status = 'static'
          claim.data = { bird: 'awwooo' }
          claim.bid_id = 'BIRD/FLY/1213'
        end
      ]
    end

    it 'calls the claims gateway' do 
      expect(claim_gateway_spy).to have_received(:get_all).with(project_id: 4)
    end

    it 'returns an array including the first claim' do
      expect(response[:claims].first).to eq(
        {
          id: 8,
          project_id: 4,
          type: 'ac',
          status: 'Submitted',
          data: { turkey: 'squark' },
          bid_id: 'AC/GF/7834'
        }
      )
    end

    it 'returns an array including the second return' do
      expect(response[:claims][1]).to eq(
        {
          id: 54,
          project_id: 3,
          type: 'blah',
          status: 'static',
          data: { bird: 'awwooo' },
          bid_id: 'BIRD/FLY/1213'
        }
      )
    end
  end
end
