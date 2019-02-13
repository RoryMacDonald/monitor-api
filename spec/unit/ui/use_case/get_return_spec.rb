# frozen_string_literal: true

describe UI::UseCase::GetReturn do
  describe 'Example one' do
    let(:convert_core_return_spy) { spy(execute: { fly: 'buz' }) }
    let(:get_return_spy) do
      spy(
        execute: {
          id: 1,
          bid_id: 'HIF/MV/6',
          type: 'cat',
          project_id: 2,
          status: 'Meow',
          updates: [{ dog: 'woof' }, { dog: 'woof' }],
          no_of_previous_returns: 5
        }
      )
    end
    let(:use_case) { described_class.new(get_return: get_return_spy, convert_core_return: convert_core_return_spy) }
    let(:response) { use_case.execute(id: 1, api_key: 'U.T.F') }

    before { response }

    it 'Calls the get return use case' do
      expect(get_return_spy).to have_received(:execute)
    end

    it 'Passes the ID to the get return usecase' do
      expect(get_return_spy).to have_received(:execute).with(hash_including(id: 1))
    end

    it 'Passes the api key to the get return usecase' do
      expect(get_return_spy).to have_received(:execute).with(hash_including(api_key: 'U.T.F'))
    end

    it 'Returns the ID from the get return use case' do
      expect(response[:id]).to eq(1)
    end

    it 'Returns the type from the get return use case' do
      expect(response[:type]).to eq('cat')
    end

    it 'Returns the bid id' do
      expect(response[:bid_id]).to eq('HIF/MV/6')
    end

    it 'Returns the project id from the get return use case' do
      expect(response[:project_id]).to eq(2)
    end

    it 'Returns the status from the get return use case' do
      expect(response[:status]).to eq('Meow')
    end

    it 'Returns the number of previous returns from the get return use case' do
      expect(response[:no_of_previous_returns]).to eq(5)
    end

    it 'Calls the convert core return use case with the data' do
      expect(convert_core_return_spy).to(
        have_received(:execute)
        .twice
        .with(return_data: { dog: 'woof' }, type: 'cat')
      )
    end

    it 'returns converted returns' do
      expect(response[:updates]).to eq([{ fly: 'buz' }, { fly: 'buz' }])
    end
  end

  describe 'Example two' do
    let(:convert_core_return_spy) { spy(execute: { goat: 'meh' }) }
    let(:get_return_spy) do
      spy(
        execute: {
          id: 5,
          bid_id: 'HIF/MV/7',
          type: 'dog',
          project_id: 7,
          status: 'Woof',
          updates: [{ duck: 'quack' }, { duck: 'quack' }],
          no_of_previous_returns: 8
        }
      )
    end
    let(:use_case) { described_class.new(get_return: get_return_spy, convert_core_return: convert_core_return_spy) }
    let(:response) { use_case.execute(id: 5, api_key: 'R.M.Q') }

    before { response }

    it 'Calls the get return use case' do
      expect(get_return_spy).to have_received(:execute)
    end

    it 'Passes the ID to the get return usecase' do
      expect(get_return_spy).to have_received(:execute).with(hash_including(id: 5))
    end

    it 'Passes the api key to the get return usecase' do
      expect(get_return_spy).to have_received(:execute).with(hash_including(api_key: 'R.M.Q'))
    end

    it 'Returns the ID from the get return use case' do
      expect(response[:id]).to eq(5)
    end

    it 'Returns the type from the get return use case' do
      expect(response[:type]).to eq('dog')
    end

    it 'Returns the bid id' do
      expect(response[:bid_id]).to eq('HIF/MV/7')
    end

    it 'Returns the project id from the get return use case' do
      expect(response[:project_id]).to eq(7)
    end

    it 'Returns the status from the get return use case' do
      expect(response[:status]).to eq('Woof')
    end

    it 'Calls the convert core return use case with the data' do
      expect(convert_core_return_spy).to(
        have_received(:execute)
        .twice
        .with(return_data: { duck: 'quack' }, type: 'dog')
      )
    end

    it 'returns converted returns' do
      expect(response[:updates]).to eq([{ goat: 'meh' }, { goat: 'meh' }])
    end

    it 'Returns the number of previous returns from the get return use case' do
      expect(response[:no_of_previous_returns]).to eq(8)
    end
  end
end
