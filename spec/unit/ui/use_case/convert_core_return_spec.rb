describe UI::UseCase::ConvertCoreReturn do
  context 'Example 1' do
    let(:convert_core_hif_return_spy) { spy(execute: { data: 'converted_return_data' })}
    let(:convert_core_ac_return_spy) { spy(execute: { data: 'converted_by_ac_return_data' })}
    let(:convert_core_ff_return_spy) { spy(execute: { data: 'converted by ff return data' })}

    let(:use_case) do
      described_class.new(
        convert_core_hif_return: convert_core_hif_return_spy,
        convert_core_ac_return: convert_core_ac_return_spy,
        convert_core_ff_return: convert_core_ff_return_spy
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

      it 'Calls the convert core hif use case' do
        expect(convert_core_hif_return_spy).to have_received(:execute).with(
          return_data: { wrong_data: 'needs to be converted' }
        )
      end

      it 'Returns the response from the hif convertor' do
        expect(response).to eq({ data: 'converted_return_data' })
      end
    end

    context 'AC data' do
      let(:response) do
        use_case.execute(
          return_data: { wrong_data: 'needs to be converted' },
          type: 'ac'
          )
      end

      before { response }

      it 'Calls the convert core ac use case' do
        expect(convert_core_ac_return_spy).to have_received(:execute).with(
          return_data: { wrong_data: 'needs to be converted' }
        )
      end

      it 'Returns the response from the ac convertor' do
        expect(response).to eq({ data: 'converted_by_ac_return_data' })
      end
    end

    context 'FF data' do
      let(:response) do
        use_case.execute(
          return_data: { wrong_data: 'needs to be converted' },
          type: 'ff'
          )
      end

      before { response }

      it 'Calls the convert core ff use case' do
        expect(convert_core_ff_return_spy).to have_received(:execute).with(
          return_data: { wrong_data: 'needs to be converted' }
        )
      end

      it 'Returns the response from the ff convertor' do
        expect(response).to eq({ data: 'converted by ff return data' })
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
        expect(convert_core_hif_return_spy).not_to have_received(:execute)
      end

      it 'returns the same data that was input' do
        expect(response).to eq({ wrong_data: 'needs to be converted' })
      end
    end
  end

  context 'Example 2' do
    let(:convert_core_hif_return_spy) { spy(execute: { my_second_return: 'Also been converted'})}
    let(:convert_core_ac_return_spy) { spy(execute: { my_second_return: 'Also been converted (by ac)'})}
    let(:convert_core_ff_return_spy) { spy(execute: { my_second_return: 'Also been converted (by ff)' })}

    let(:use_case) do
      described_class.new(
        convert_core_hif_return: convert_core_hif_return_spy,
        convert_core_ac_return: convert_core_ac_return_spy,
        convert_core_ff_return: convert_core_ff_return_spy
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

      it 'Calls the convert core hif use case' do
        expect(convert_core_hif_return_spy).to have_received(:execute).with(
          return_data: { before_conversion: 'Must check type' }
        )
      end

      it 'Returns the response from the hif convertor' do
        expect(response).to eq({ my_second_return: 'Also been converted'})
      end
    end

    context 'AC data' do
      let(:response) do
        use_case.execute(
          return_data: { before_conversion: 'Must check type' },
          type: 'ac'
          )
      end

      before { response }

      it 'Calls the convert core ac use case' do
        expect(convert_core_ac_return_spy).to have_received(:execute).with(
          return_data: { before_conversion: 'Must check type' }
        )
      end

      it 'Returns the response from the ac convertor' do
        expect(response).to eq({ my_second_return: 'Also been converted (by ac)'})
      end
    end

    context 'FF data' do
      let(:response) do
        use_case.execute(
          return_data: { before_conversion: 'Must check type' },
          type: 'ff'
          )
      end

      before { response }

      it 'Calls the convert core ff use case' do
        expect(convert_core_ff_return_spy).to have_received(:execute).with(
          return_data: { before_conversion: 'Must check type' }
        )
      end

      it 'Returns the response from the ff convertor' do
        expect(response).to eq({ my_second_return: 'Also been converted (by ff)'})
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
        expect(convert_core_hif_return_spy).not_to have_received(:execute)
      end

      it 'returns the same data that was input' do
        expect(response).to eq({ before_conversion: 'Must check type' })
      end
    end
  end
end
