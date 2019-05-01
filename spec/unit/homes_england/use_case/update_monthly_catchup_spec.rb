describe HomesEngland::UseCase::UpdateMonthlyCatchup do
  let(:monthly_catchup_gateway) { spy }

  let(:usecase) do
    described_class
      .new(monthly_catchup_gateway: monthly_catchup_gateway)
  end

  context 'example 1' do
    let(:monthly_catchup_data) { { date: '09/09/1978' } }
    it 'Calls the update method on the gateway' do
      usecase
        .execute(monthly_catchup_id: 3, monthly_catchup_data: monthly_catchup_data)

      expect(monthly_catchup_gateway).to have_received(:update) do |monthly_catchup|
        expect(monthly_catchup.id).to eq(3)
        expect(monthly_catchup.data).to eq(monthly_catchup_data)
      end
    end
  end

  context 'example 2' do
    let(:monthly_catchup_data) { { date: '12/09/1980' } }

    it 'Calls the update method on the gateway' do
      usecase
        .execute(monthly_catchup_id: 8, monthly_catchup_data: monthly_catchup_data)

      expect(monthly_catchup_gateway).to have_received(:update) do |monthly_catchup|
        expect(monthly_catchup.id).to eq(8)
        expect(monthly_catchup.data).to eq(monthly_catchup_data)
      end
    end
  end
end
