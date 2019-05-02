fdescribe HomesEngland::UseCase::GetBaseMonthlyCatchup do
  let(:monthly_catchup_template_gateway_spy) do
    spy(
      execute: Common::Domain::Template.new.tap do |template|
        template.schema = schema
      end
    )
  end

  let(:usecase) do
    described_class.new(
      find_project: find_project_spy,
      monthly_catchup_template_gateway: monthly_catchup_template_gateway_spy
    )
  end

  context 'example 1' do
    let(:schema) do
      {
        type: 'string'
      }
    end

    let(:find_project_spy) { spy(execute: { type: 'hif' }) }
    it 'calls the find project use case' do
      usecase.execute(project_id: 1)
      expect(find_project_spy).to have_received(:execute).with(id: 1)
    end

    it 'calls the monthly catchup template gateway' do
      usecase.execute(project_id: 1)
      expect(monthly_catchup_template_gateway_spy).to have_received(:execute).with(type: 'hif')
    end

    it 'returns the appropriate data' do
      expect(usecase.execute(project_id: 1)).to eq({
        base_monthly_catchup: {
          project_id: 1,
          data: {},
          schema: {
            type: 'string'
          }
        }
      })
    end
  end

  context 'example 2' do
    let(:schema) do
      {
        type: 'object',
        properties: {}
      }
    end

    let(:find_project_spy) { spy(execute: { type: 'ac' }) }
    it 'calls the find project use case' do
      usecase.execute(project_id: 2)
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'calls the monthly catchup template gateway' do
      usecase.execute(project_id: 2)
      expect(monthly_catchup_template_gateway_spy).to have_received(:execute).with(type: 'ac')
    end

    it 'returns the appropriate data' do
      expect(usecase.execute(project_id: 2)).to eq({
        base_monthly_catchup: {
          project_id: 2,
          data: {},
          schema: {
            type: 'object',
            properties: {}
          }
        }
      })
    end
  end
end
