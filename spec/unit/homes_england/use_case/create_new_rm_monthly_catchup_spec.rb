require 'rspec'

describe HomesEngland::UseCase::CreateNewRmMonthlyCatchup do
  let(:monthly_catchup_id) { 0 }
  let(:monthly_catchup_gateway) { spy(create: monthly_catchup_id) }
  let(:project_gateway) { spy }
  let(:use_case) { described_class.new(monthly_catchup_gateway: monthly_catchup_gateway) }

  context 'calls create in monthly_catchup gateway' do
    example 1 do
      use_case.execute(project_id: 3, monthly_catchup_data: {})
      expect(monthly_catchup_gateway).to have_received(:create) do |monthly_catchup|
        expect(monthly_catchup.project_id).to eq(3)
        expect(monthly_catchup.data).to eq({})
        expect(monthly_catchup.status).to eq('Draft')
      end
    end

    example 2 do
      use_case.execute(project_id: 7, monthly_catchup_data: {
        date: '24/01/2001'
      })
      expect(monthly_catchup_gateway).to have_received(:create) do |monthly_catchup|
        expect(monthly_catchup.project_id).to eq(7)
        expect(monthly_catchup.data).to eq({ date: '24/01/2001' })
        expect(monthly_catchup.status).to eq('Draft')
      end
    end
  end

  context 'return value' do
    context 'example 1' do
      let(:monthly_catchup_id) { 1 }

      it 'returns the correct id' do
        response = use_case.execute(project_id: 7, monthly_catchup_data: {
          date: '24/01/2001'
        })

        expect(response[:id]).to eq(1)
      end
    end

    context 'example 2' do
      let(:monthly_catchup_id) { 2 }

      it 'returns the correct id' do
        response = use_case.execute(project_id: 2, monthly_catchup_data: {
          date: '09/05/2001'
        })

        expect(response[:id]).to eq(2)
      end
    end
  end
end
