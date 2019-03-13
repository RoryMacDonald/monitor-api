describe HomesEngland::UseCase::SubmitBaseline do
  let(:baseline_gateway) { spy }
  let(:usecase) { described_class.new(baseline_gateway: baseline_gateway) }
  before { usecase.execute(id: id) }
  
  context 'Example 1' do
    let(:id) { 34 }
    it 'calls the submit method on the gateway with the baseline id' do
      expect(baseline_gateway).to have_received(:submit).with(id: 34)
    end
  end

  context 'Example 2' do
    let(:id) { 367 }
    it 'calls the submit method on the gateway with the baseline id' do
      expect(baseline_gateway).to have_received(:submit).with(id: 367)
    end
  end
end