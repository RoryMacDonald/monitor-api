describe UI::UseCase::UiCreateMonthlyCatchup do

  let(:usecase) { described_class.new(
    convert_ui_monthly_catchup: convert_ui_monthly_catchup_spy,
    create_monthly_catchup: create_monthly_catchup_spy,
    find_project: find_project_spy
  )}

  context 'example 1' do
    let(:find_project_spy) { spy(execute: {type: 'hif'}) }
    let(:convert_ui_monthly_catchup_spy) { spy(execute: {data: 'cat' }) }
    let(:create_monthly_catchup_spy) { spy(execute: { id: 66 }) }
    let(:response) { usecase.execute(project_id: 2, monthly_catchup_data:{}) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'calls convert ui monthly_catchup' do
      response
      expect(convert_ui_monthly_catchup_spy).to have_received(:execute).with(type: 'hif',monthly_catchup_data: {})
    end

    it 'calls create monthly_catchup' do
      response
      expect(create_monthly_catchup_spy).to have_received(:execute).with(project_id: 2, monthly_catchup_data: { data: 'cat' })
    end

    it 'returns the created monthly_catchup id' do
      expect(response[:id]).to eq(66)
    end
  end

  context 'example 2' do
    let(:find_project_spy) { spy(execute: {type: 'ac'}) }
    let(:convert_ui_monthly_catchup_spy) { spy(execute: {data: 'dog'}) }
    let(:create_monthly_catchup_spy) { spy(execute: { id: 99 }) }
    let(:response) { usecase.execute(project_id: 7, monthly_catchup_data:{ date: '10/10/1010'}) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    it 'calls convert ui monthly_catchup' do
      response
      expect(convert_ui_monthly_catchup_spy).to have_received(:execute).with(type: 'ac', monthly_catchup_data: { date: '10/10/1010' })
    end

    it 'calls create monthly_catchup' do
      response
      expect(create_monthly_catchup_spy).to have_received(:execute).with(project_id: 7, monthly_catchup_data: { data: 'dog' })
    end

    it 'returns the created monthly_catchup id' do
      expect(response[:id]).to eq(99)
    end
  end
end
