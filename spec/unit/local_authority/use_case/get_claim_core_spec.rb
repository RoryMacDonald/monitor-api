describe LocalAuthority::UseCase::GetClaimCore do
  let(:usecase) { described_class.new(claim_gateway: claim_gateway_spy) }

  context 'example 1' do
    let(:claim_gateway_spy) do
      spy(
        find_by: LocalAuthority::Domain::Claim.new.tap do |claim|
          claim.id = 161
          claim.project_id = 0
          claim.type = 'hif'
          claim.status = 'Draft'
          claim.bid_id = 55
          claim.data = {
            infrastructures: [
              { name: "infrastructure 1"}
            ]
          }
        end
      )
    end

    it 'calls the claim gateway' do
      usecase.execute(claim_id: 161)
      expect(claim_gateway_spy).to have_received(:find_by).with(claim_id: 161)
    end

    it 'returns the appropriate data' do
      response = usecase.execute(claim_id: 161)
      expect(response[:id]).to eq(161)
      expect(response[:status]).to eq('Draft')
      expect(response[:project_id]).to eq(0)
      expect(response[:type]).to eq('hif')
      expect(response[:bid_id]).to eq(55)
      expect(response[:data]).to eq({
        infrastructures: [
          { name: "infrastructure 1"}
        ]
      })
    end
  end

  context 'example 2' do
    let(:claim_gateway_spy) do
      spy(
        find_by: LocalAuthority::Domain::Claim.new.tap do |claim|
          claim.id = 128
          claim.project_id = 6
          claim.type = 'ac'
          claim.status = 'Submitted'
          claim.bid_id = 11
          claim.data = {
            startDate: "01/01/2000"
          }
        end
      )
    end

    it 'calls the claim gateway' do
      usecase.execute(claim_id: 128)
      expect(claim_gateway_spy).to have_received(:find_by).with(claim_id: 128)
    end

    it 'returns the appropriate data' do
      response = usecase.execute(claim_id: 128)
      expect(response[:id]).to eq(128)
      expect(response[:status]).to eq('Submitted')
      expect(response[:project_id]).to eq(6)
      expect(response[:type]).to eq('ac')
      expect(response[:bid_id]).to eq(11)
      expect(response[:data]).to eq({
        startDate: "01/01/2000"
      })
    end
  end
end
