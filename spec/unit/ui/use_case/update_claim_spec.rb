describe UI::UseCase::UpdateClaim do
  context 'example 1' do
    let(:get_claim_spy) { spy(execute: { type: 'hif' }) }
    let(:update_claim_spy) { spy }
    let(:convert_ui_claim_spy) { spy(execute: { converted_data: "converted value" }) }
    let(:usecase) do
      described_class.new(
        get_claim: get_claim_spy,
        update_claim_core: update_claim_spy,
        convert_ui_claim: convert_ui_claim_spy
      )
    end

    it 'calls get claim' do
      usecase.execute(claim_id: 3, claim_data: {})
      expect(get_claim_spy).to have_received(:execute).with(claim_id: 3)
    end

    it 'calls convert ui claim' do
      usecase.execute(claim_id: 3, claim_data: {})
      expect(convert_ui_claim_spy).to have_received(:execute).with(claim_data: {}, type: 'hif')
    end

    it 'calls update claim core' do
      usecase.execute(claim_id: 3, claim_data: {})
      expect(update_claim_spy).to have_received(:execute).with(claim_id: 3, claim_data: { converted_data: "converted value" })
    end
  end

  context 'example 2' do
    let(:get_claim_spy) { spy(execute: { type: 'ac' }) }
    let(:update_claim_spy) { spy }
    let(:convert_ui_claim_spy) { spy(execute: { converted_data_2: "converted value 2" }) }
    let(:usecase) do
      described_class.new(
        get_claim: get_claim_spy,
        update_claim_core: update_claim_spy,
        convert_ui_claim: convert_ui_claim_spy
      )
    end

    it 'calls get claim' do
      usecase.execute(claim_id: 5, claim_data: { original_key: "original value" })
      expect(get_claim_spy).to have_received(:execute).with(claim_id: 5)
    end

    it 'calls convert ui claim' do
      usecase.execute(claim_id: 5, claim_data: { original_key: "original value" })
      expect(convert_ui_claim_spy).to have_received(:execute).with(claim_data: { original_key: "original value" }, type: 'ac')
    end

    it 'calls update claim core' do
      usecase.execute(claim_id: 5, claim_data: { original_key: "original value" })
      expect(update_claim_spy).to have_received(:execute).with(claim_id: 5, claim_data: { converted_data_2: "converted value 2" })
    end
  end
end
