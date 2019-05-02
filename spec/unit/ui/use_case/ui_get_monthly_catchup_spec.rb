describe UI::UseCase::UiGetMonthlyCatchup do
  let(:schema) { nil }
  let(:usecase) { described_class.new(
    convert_core_monthly_catchup: convert_core_monthly_catchup_spy,
    get_monthly_catchup: get_monthly_catchup_spy,
    find_project: find_project_spy,
    catchup_schema_gateway: in_memory_monthly_catchup_schema_gateway_spy
  )}

  let(:in_memory_monthly_catchup_schema_gateway_spy) { spy(find_by: UI::Domain::Schema.new.tap { |s| s.schema = schema }) }

  context 'example 1' do
    let(:schema) do
      {
        type: 'object',
        properties: {
          date: {
            type: 'string'
          }
        }
      }
    end

    let(:find_project_spy) { spy(execute: { type: 'hif' }) }
    let(:get_monthly_catchup_spy) { spy(execute: { id: 1, data: { animal: 'fox' }, status: 'Draft' }) }
    let(:convert_core_monthly_catchup_spy) { spy(execute: { animal: 'dog'}) }
    let(:response) { usecase.execute(project_id: 1, monthly_catchup_id: 1) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 1)
    end

    it 'calls get monthly_catchup' do
      response
      expect(get_monthly_catchup_spy).to have_received(:execute).with(monthly_catchup_id: 1)
    end

    it 'calls convert core monthly_catchup' do
      response
      expect(convert_core_monthly_catchup_spy).to have_received(:execute).with(type: 'hif', monthly_catchup_data: { animal: 'fox' })
    end

    it 'returns the monthly_catchup' do
      expect(response[:id]).to eq(1)
      expect(response[:project_id]).to eq(1)
      expect(response[:data]).to eq({ animal: 'dog' })
      expect(response[:status]).to eq('Draft')
      expect(response[:schema]).to eq(schema)
    end

    it 'calls the in memory monthly catchup schema gateway' do
      response
      expect(in_memory_monthly_catchup_schema_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end
  end

  context 'example 2' do
    let(:schema) do
      {
        type: 'string'
      }
    end

    let(:find_project_spy) { spy(execute: { type: 'ac' }) }
    let(:get_monthly_catchup_spy) { spy(execute: { id: 2, data: { name: 'moon moon' }, status: 'Submitted' }) }
    let(:convert_core_monthly_catchup_spy) { spy(execute: { name: 'doggo' }) }
    let(:response) { usecase.execute(project_id: 2, monthly_catchup_id: 2) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'calls get monthly_catchup' do
      response
      expect(get_monthly_catchup_spy).to have_received(:execute).with(monthly_catchup_id: 2)
    end

    it 'calls convert core monthly_catchup' do
      response
      expect(convert_core_monthly_catchup_spy).to have_received(:execute).with(type: 'ac', monthly_catchup_data: { name: 'moon moon' })
    end

    it 'returns the monthly_catchup' do
      expect(response[:id]).to eq(2)
      expect(response[:project_id]).to eq(2)
      expect(response[:data]).to eq({ name: 'doggo' })
      expect(response[:status]).to eq('Submitted')
      expect(response[:schema]).to eq(schema)
    end

    it 'calls the in memory monthly catchup schema gateway' do
      response
      expect(in_memory_monthly_catchup_schema_gateway_spy).to have_received(:find_by).with(type: 'ac')
    end
  end
end
