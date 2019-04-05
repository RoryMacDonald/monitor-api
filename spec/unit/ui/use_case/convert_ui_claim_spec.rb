describe UI::UseCase::ConvertUIClaim do
  context 'example 1' do
    let(:convert_ui_hif_claim_spy) { spy(execute: { data: 'hif data' }) }
    let(:convert_ui_ac_claim_spy) { spy(execute: { data: 'ac data' }) }
    let(:convert_ui_ff_claim_spy) { spy(execute: { data: 'ff data' }) }
    let(:sanitise_data_spy) { spy(execute: {data: 'nonempty'}) }

    let(:usecase) do
      described_class.new(
        convert_ui_ac_claim: convert_ui_ac_claim_spy,
        convert_ui_hif_claim: convert_ui_hif_claim_spy,
        convert_ui_ff_claim: convert_ui_ff_claim_spy,
        sanitise_data: sanitise_data_spy
      )
    end

    it 'sanitises the data' do
      usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })

      expect(sanitise_data_spy).to have_received(:execute).with(
        data: { data: 'hif data' }
      )
    end

    context 'hif' do
      it 'calls the convert use case' do
        usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })
        expect(convert_ui_hif_claim_spy).to have_received(:execute).with(
          claim_data: { some_data: 'data value' }
        )
      end
    end

    context 'ac' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ac', claim_data: { some_data: 'data value' })
        expect(convert_ui_ac_claim_spy).to have_received(:execute).with(
          claim_data: { some_data: 'data value' }
        )
      end
    end

    context 'ff' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ff', claim_data: { other_data: 'ff data' })
        expect(convert_ui_ff_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'ff data' }
        )
      end
    end

    it 'returns the sanitised data' do
      response = usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })

      expect(response).to eq({data: 'nonempty'})
    end
  end

  context 'example 2' do
    let(:convert_ui_hif_claim_spy) { spy(execute: { data: 'converted return data' }) }
    let(:convert_ui_ac_claim_spy) { spy(execute: { data: 'ac converted return data' }) }
    let(:convert_ui_ff_claim_spy) { spy(execute: { data: 'ff converted return data' }) }
    let(:sanitise_data_spy) { spy(execute: {data: 'no nils'}) }

    let(:usecase) do
      described_class.new(
        convert_ui_ac_claim: convert_ui_ac_claim_spy,
        convert_ui_hif_claim: convert_ui_hif_claim_spy,
        convert_ui_ff_claim: convert_ui_ff_claim_spy,
        sanitise_data: sanitise_data_spy
      )
    end

    it 'sanitises the data' do
      usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })

      expect(sanitise_data_spy).to have_received(:execute).with(
        data: { data: 'converted return data' }
      )
    end

    context 'hif' do
      it 'calls the convert use case' do
        usecase.execute(type: 'hif', claim_data: { other_data: 'data' })
        expect(convert_ui_hif_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'data' }
        )
      end
    end

    context 'ac' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ac', claim_data: { other_data: 'data' })
        expect(convert_ui_ac_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'data' }
        )
      end
    end

    context 'ff' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ff', claim_data: { other_data: 'data' })
        expect(convert_ui_ff_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'data' }
        )
      end
    end

    it 'returns the sanitised data' do
      response = usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })

      expect(response).to eq({data: 'no nils'})
    end
  end
end
