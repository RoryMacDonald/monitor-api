
describe UI::UseCase::ConvertUIReturn do
  context 'Example 1' do
    let(:convert_ui_hif_return_spy) { spy(execute: { data: 'converted_return_data' })}
    let(:convert_ui_ac_return_spy) { spy(execute: { data: 'ac_converted_return_data' })}
    let(:use_case) do
      described_class.new(
        convert_ui_hif_return: convert_ui_hif_return_spy,
        convert_ui_ac_return: convert_ui_ac_return_spy
      )
    end

    context 'HIF data' do
      let(:response) do
        use_case.execute(
          return_data: { wrong_data: 'needs to be converted' },
          type: 'hif'
          )
      end

      before { response }

      it 'Calls the convert ui hif use case' do
        expect(convert_ui_hif_return_spy).to have_received(:execute).with(
          return_data: { wrong_data: 'needs to be converted' }
        )
      end

      it 'Returns the response from the hif convertor' do
        expect(response).to eq({ data: 'converted_return_data' })
      end
    end

    context 'ac data' do
      let(:response) do
        use_case.execute(
          return_data: { wrong_data: 'needs to be converted' },
          type: 'ac'
          )
      end

      before { response }

      it 'Calls the convert ui ac use case' do
        expect(convert_ui_ac_return_spy).to have_received(:execute).with(
          return_data: { wrong_data: 'needs to be converted' }
        )
      end

      it 'Returns the response from the ac convertor' do
        expect(response).to eq({ data: 'ac_converted_return_data' })
      end
    end

    context 'a different type of data' do
      let(:response) do
        use_case.execute(
          return_data: { wrong_data: 'needs to be converted' },
          type: 'different type '
          )
      end

      before { response }

      it 'doesnt call the convert hif use case' do
        expect(convert_ui_hif_return_spy).not_to have_received(:execute)
      end

      it 'returns the same data that was input' do
        expect(response).to eq({ wrong_data: 'needs to be converted' })
      end
    end
  end

  context 'Example 2' do
    let(:convert_ui_hif_return_spy) { spy(execute: { my_second_return: 'Also been converted'})}
    let(:convert_ui_ac_return_spy) { spy(execute: { my_second_return: 'Also been converted by ac'})}
    let(:use_case) do
      described_class.new(
        convert_ui_hif_return: convert_ui_hif_return_spy,
        convert_ui_ac_return: convert_ui_ac_return_spy
      )
    end

    context 'HIF data' do
      let(:response) do
        use_case.execute(
          return_data: { before_conversion: 'Must check type' },
          type: 'hif'
          )
      end

      before { response }

      it 'Calls the convert ui hif use case' do
        expect(convert_ui_hif_return_spy).to have_received(:execute).with(
          return_data: { before_conversion: 'Must check type' }
        )
      end

      it 'Returns the response from the hif convertor' do
        expect(response).to eq({ my_second_return: 'Also been converted'})
      end
    end

    context 'ac data' do
      let(:response) do
        use_case.execute(
          return_data: { before_conversion: 'Must check type' },
          type: 'ac'
          )
      end

      before { response }

      it 'Calls the convert ui ac use case' do
        expect(convert_ui_ac_return_spy).to have_received(:execute).with(
          return_data: { before_conversion: 'Must check type' }
        )
      end

      it 'Returns the response from the ac convertor' do
        expect(response).to eq({ my_second_return: 'Also been converted by ac'})
      end
    end

    context 'a different type of data' do
      let(:response) do
        use_case.execute(
          return_data: { before_conversion: 'Must check type' },
          type: 'not another type'
          )
      end

      before { response }

      it 'doesnt call the convert hif use case' do
        expect(convert_ui_hif_return_spy).not_to have_received(:execute)
      end

      it 'returns the same data that was input' do
        expect(response).to eq({ before_conversion: 'Must check type' })
      end
    end
  end
end
