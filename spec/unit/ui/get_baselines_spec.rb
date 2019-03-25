describe UI::UseCase::GetBaselines do
  let(:usecase) do
    described_class.new(
      get_baselines: get_baseline_spy,
      convert_core_project: convert_core_project_spy,
      find_project: find_project_spy
    )
  end

  let(:response) { usecase.execute(project_id: project_id)}
  before { response }

  context 'Example 1' do
    let(:project_id) { 1 }
    let(:convert_core_project_spy) { spy(execute: { data: 'one' }) }
    let(:get_baseline_spy) do
      spy(execute: { baselines: 
        [
          { data: {new: '2'}, id: 1 },
          { data: {new: '2'}, id: 6 }
        ]
      })
    end
  
    let(:find_project_spy) do
      spy(execute: {type: 'ac'})
    end

    it 'calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(
        id: 1
      )
    end

    it 'calls the get baselines use case' do
      expect(get_baseline_spy).to have_received(:execute).with(
        project_id: 1
      )
    end

    it 'calls the convertor use case' do
      expect(convert_core_project_spy).to have_received(:execute).twice.with(
        type: 'ac',
        project_data: {new: '2'}
      )
    end

    it 'returns converted data' do
      expect(response[:baselines]).to eq([
        { data: { data: 'one' }, id: 1 },
        { data: { data: 'one' }, id: 6 }
      ])
    end
  end

  context 'Example 2' do
    let(:project_id) { 3 }
    let(:convert_core_project_spy) { spy(execute: { data: 'two' }) }
    let(:get_baseline_spy) do
      spy(execute: { baselines: 
        [
          { data: {new: '3'}, id: 5 },
          { data: {new: '3'}, id: 7 }
        ]
      })
    end
  
    let(:find_project_spy) do
      spy(execute: {type: 'ff'})
    end

    it 'calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(
        id: 3
      )
    end

    it 'calls the get baselines use case' do
      expect(get_baseline_spy).to have_received(:execute).with(
        project_id: 3
      )
    end

    it 'calls the convertor use case' do
      expect(convert_core_project_spy).to have_received(:execute).twice.with(
        type: 'ff',
        project_data: {new: '3'}
      )
    end

    it 'returns converted data' do
      expect(response[:baselines]).to eq([
        { data: { data: 'two' }, id: 5 },
        { data: { data: 'two' }, id: 7 }
      ])
    end
  end
end
