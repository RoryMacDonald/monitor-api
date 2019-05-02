fdescribe UI::UseCase::GetBaseMonthlyCatchup do
  let(:find_project_spy) {
    spy(execute: {
      type: type
    })
  }
  let(:monthly_catchup_schema_gateway_spy) do
    spy(
      find_by: Common::Domain::Template.new.tap do |t|
        t.schema = schema
      end
    )
  end
  let(:get_base_monthly_catchup_spy) do
    spy(execute: {base_monthly_catchup: base_monthly_catchup})
  end
  let(:convert_core_monthly_catchup_spy) { spy(execute: converted_data) }
  let(:usecase) do
    described_class.new(
      get_base_monthly_catchup: get_base_monthly_catchup_spy,
      convert_core_monthly_catchup: convert_core_monthly_catchup_spy,
      monthly_catchup_schema_gateway: monthly_catchup_schema_gateway_spy,
      find_project: find_project_spy
    )
  end

  context 'example 1' do
    let(:type) { 'hif' }
    let(:converted_data) { { converted_date: '25/08/2000' } }
    let(:schema) { {
      type: 'string'
    } }
    let(:base_monthly_catchup) do
      {
        project_id: 10,
        schema: {
          type: 'object'
        },
        data: { date: '25/08/2000' }
      }
    end

    it 'calls the get_base_monthly catchup usecase' do
      usecase.execute(project_id: 10)
      expect(get_base_monthly_catchup_spy).to have_received(:execute).with(project_id: 10)
    end

    it 'calls convert core monthly catchup' do
      usecase.execute(project_id: 10)
      expect(convert_core_monthly_catchup_spy).to have_received(:execute).with(type: 'hif', monthly_catchup_data: { date: '25/08/2000' })
    end

    it 'calls the monthly catchup schema gateway' do
      usecase.execute(project_id: 10)
      expect(monthly_catchup_schema_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end

    it 'calls find project' do
      usecase.execute(project_id: 10)
      expect(find_project_spy).to have_received(:execute).with(id: 10)
    end

    it 'returns the correct data' do
      response = usecase.execute(project_id: 10)
      expect(response).to eq({
        project_id: 10,
        schema: {
          type: 'string'
        },
        data: { converted_date: '25/08/2000' }
      })
    end
  end

  context 'example 2' do
    let(:type) { 'ac' }
    let(:converted_data) { { converted_date: '17/12/1998' } }
    let(:schema) { {} }
    let(:base_monthly_catchup) do
      {
        project_id: 9,
        schema: {
          type: 'string'
        },
        data: { date: '17/12/1998' }
      }
    end

    it 'calls the get_base_monthly catchup usecase' do
      usecase.execute(project_id: 9)
      expect(get_base_monthly_catchup_spy).to have_received(:execute).with(project_id: 9)
    end

    it 'calls convert_core_monthly_catchup' do
      usecase.execute(project_id: 9)
      expect(convert_core_monthly_catchup_spy).to have_received(:execute).with(type: 'ac', monthly_catchup_data: { date: '17/12/1998' })
    end

    it 'calls the monthly catchup schema gateway' do
      usecase.execute(project_id: 9)
      expect(monthly_catchup_schema_gateway_spy).to have_received(:find_by).with(type: 'ac')
    end

    it 'calls find project' do
      usecase.execute(project_id: 9)
      expect(find_project_spy).to have_received(:execute).with(id: 9)
    end

    it 'returns the correct data' do
      response = usecase.execute(project_id: 9)
      expect(response).to eq({
        project_id: 9,
        schema: {},
        data: { converted_date: '17/12/1998' }
      })
    end
  end
end
