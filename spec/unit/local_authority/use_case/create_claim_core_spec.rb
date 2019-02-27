describe LocalAuthority::UseCase::CreateClaimCore do
  let(:claim_id) { 3 }
  let(:claim_gateway_spy) { spy(create: claim_id) }
  let(:usecase) { described_class.new(claim_gateway: claim_gateway_spy) }

  context 'example 1' do
    let(:claim_id) { 7 }

    it 'calls create on the gateway' do
      claim_data = {
        claimSummary: {
          hifTotalFundingRequest: "16111"
        }
      }
      usecase.execute(project_id: 1, claim_data: claim_data)
      expect(claim_gateway_spy).to have_received(:create) do |claim|
        expect(claim.project_id).to eq(1)
        expect(claim.data).to eq(claim_data)
      end
    end

    it 'returns the claim id' do
      claim_data = {
        claimSummary: {
          SpendToDate: "1737"
        }
      }
      response = usecase.execute(project_id: 3, claim_data: claim_data)
      expect(response[:claim_id]).to eq(7)
    end
  end

  context 'example 2' do
    let(:claim_id) { 8 }

    it 'calls create on the gateway' do
      claim_data = {
        claimSummary: {
          SpendToDate: "1737"
        }
      }
      usecase.execute(project_id: 3, claim_data: claim_data)
      expect(claim_gateway_spy).to have_received(:create) do |claim|
        expect(claim.project_id).to eq(3)
        expect(claim.data).to eq(claim_data)
      end
    end

    it 'returns the claim id' do
      claim_data = {
        claimSummary: {
          SpendToDate: "1737"
        }
      }
      response = usecase.execute(project_id: 3, claim_data: claim_data)
      expect(response[:claim_id]).to eq(8)
    end
  end
end
