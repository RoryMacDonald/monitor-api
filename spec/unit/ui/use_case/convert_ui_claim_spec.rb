describe UI::UseCase::ConvertUIClaim do
  context 'example 1' do
    let(:convert_ui_hif_claim_spy) { spy(execute: { data: 'hif data' }) }
    let(:convert_ui_ac_claim_spy) { spy(execute: { data: 'ac data' }) }
    let(:convert_ui_ff_claim_spy) { spy(execute: { data: 'ff data' }) }

    let(:usecase) do
      described_class.new(
        convert_ui_ac_claim: convert_ui_ac_claim_spy,
        convert_ui_hif_claim: convert_ui_hif_claim_spy,
        convert_ui_ff_claim: convert_ui_ff_claim_spy
      )
    end

    context 'hif' do
      it 'calls the convert use case' do
        usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })
        expect(convert_ui_hif_claim_spy).to have_received(:execute).with(
          claim_data: { some_data: 'data value' }
        )
      end

      it 'returns the data' do
        response = usecase.execute(type: 'hif', claim_data: { some_data: 'data value' })
        expect(response).to eq({ data: 'hif data' })
      end
    end

    context 'ac' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ac', claim_data: { some_data: 'data value' })
        expect(convert_ui_ac_claim_spy).to have_received(:execute).with(
          claim_data: { some_data: 'data value' }
        )
      end

      it 'returns the data' do
        response = usecase.execute(type: 'ac', claim_data: { some_data: 'data value' })
        expect(response).to eq({ data: 'ac data' })
      end
    end

    context 'ff' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ff', claim_data: { other_data: 'ff data' })
        expect(convert_ui_ff_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'ff data' }
        )
      end

      it 'returns the data' do
        response = usecase.execute(type: 'ff', claim_data: { other_data: 'data' })
        expect(response).to eq({ data: 'ff data' })
      end
    end
  end

  context 'example 2' do
    let(:convert_ui_hif_claim_spy) { spy(execute: { data: 'converted return data' }) }
    let(:convert_ui_ac_claim_spy) { spy(execute: { data: 'ac converted return data' }) }
    let(:convert_ui_ff_claim_spy) { spy(execute: { data: 'ff converted return data' }) }

    let(:usecase) do
      described_class.new(
        convert_ui_ac_claim: convert_ui_ac_claim_spy,
        convert_ui_hif_claim: convert_ui_hif_claim_spy,
        convert_ui_ff_claim: convert_ui_ff_claim_spy
      )
    end

    context 'hif' do
      it 'calls the convert use case' do
        usecase.execute(type: 'hif', claim_data: { other_data: 'data' })
        expect(convert_ui_hif_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'data' }
        )
      end

      it 'returns the data' do
        response = usecase.execute(type: 'hif', claim_data: { other_data: 'data' })
        expect(response).to eq({ data: 'converted return data' })
      end
    end

    context 'ac' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ac', claim_data: { other_data: 'data' })
        expect(convert_ui_ac_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'data' }
        )
      end

      it 'returns the data' do
        response = usecase.execute(type: 'ac', claim_data: { other_data: 'data' })
        expect(response).to eq({ data: 'ac converted return data' })
      end
    end

    context 'ff' do
      it 'calls the convert use case' do
        usecase.execute(type: 'ff', claim_data: { other_data: 'data' })
        expect(convert_ui_ff_claim_spy).to have_received(:execute).with(
          claim_data: { other_data: 'data' }
        )
      end

      it 'returns the data' do
        response = usecase.execute(type: 'ff', claim_data: { other_data: 'data' })
        expect(response).to eq({ data: 'ff converted return data' })
      end
    end
  end
end
