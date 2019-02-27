describe LocalAuthority::UseCase::UpdateClaimCore do
  let(:claim_gateway_spy) { spy }
  let(:usecase) { described_class.new(claim_gateway: claim_gateway_spy)}

  context 'example 1' do
    it 'calls the claim gateway' do
      usecase.execute(claim_id: 1, claim_data: {})
      expect(claim_gateway_spy).to have_received(:update) do |update|
        expect(update[:claim_id]).to eq(1)
        expect(update[:claim].data).to eq({})
      end
    end
  end

  context 'example 2' do
    it 'calls the claim gateway' do
      usecase.execute(claim_id: 3, claim_data: { claim_name: "my claim" })
      expect(claim_gateway_spy).to have_received(:update) do |update|
        expect(update[:claim_id]).to eq(3)
        expect(update[:claim].data).to eq({ claim_name: "my claim" })
      end
    end
  end
end
