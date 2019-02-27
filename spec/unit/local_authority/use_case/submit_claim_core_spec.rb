describe LocalAuthority::UseCase::SubmitClaimCore do
  let(:claim_gateway_spy) { spy }
  let(:usecase) { described_class.new(claim_gateway: claim_gateway_spy) }
  context 'example 1' do
    it 'calls the gateway' do
      usecase.execute(claim_id: 1)
      expect(claim_gateway_spy).to have_received(:submit).with(claim_id: 1)
    end
  end

  context 'example 2' do
    it 'calls the gateway' do
      usecase.execute(claim_id: 255)
      expect(claim_gateway_spy).to have_received(:submit).with(claim_id: 255)
    end
  end
end
