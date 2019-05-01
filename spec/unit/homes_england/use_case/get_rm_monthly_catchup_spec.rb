describe HomesEngland::UseCase::GetRmMonthlyCatchup do

  let(:monthly_catchup_gateway_spy) { spy(find_by: monthly_catchup) }
  let(:get_monthly_catchup) do
    described_class.new(monthly_catchup_gateway: monthly_catchup_gateway_spy)
  end

  context 'example 1' do
    let(:monthly_catchup) do
      HomesEngland::Domain::RmMonthlyCatchup.new.tap do | monthly_catchup |
        monthly_catchup.id = 1
        monthly_catchup.project_id = 2
        monthly_catchup.data = {cats: 'feed me'}
        monthly_catchup.status = 'Draft'
      end
    end

    it 'calls the monthly_catchup gateway with find_by' do
      get_monthly_catchup.execute(monthly_catchup_id: 1)

      expect(monthly_catchup_gateway_spy).to have_received(:find_by).with(id: 1)
    end

    it 'returns a hash of a monthly_catchup' do
      monthly_catchup = get_monthly_catchup.execute(monthly_catchup_id: 1)

      expect(monthly_catchup[:id]).to eq(1)
      expect(monthly_catchup[:project_id]).to eq(2)
      expect(monthly_catchup[:data]).to eq({ cats: 'feed me'})
      expect(monthly_catchup[:status]).to eq('Draft')
    end
  end

  context 'example 2' do
    let(:monthly_catchup) do
      HomesEngland::Domain::RmMonthlyCatchup.new.tap do | monthly_catchup |
        monthly_catchup.id = 3
        monthly_catchup.project_id = 7
        monthly_catchup.data = {cats: 'in hats'}
        monthly_catchup.status = 'Submitted'
      end
    end

    it 'calls the monthly_catchup gateway with find_by' do
      get_monthly_catchup.execute(monthly_catchup_id: 3)

      expect(monthly_catchup_gateway_spy).to have_received(:find_by).with(id: 3)
    end

    it 'returns a hash of a monthly_catchup' do
      monthly_catchup = get_monthly_catchup.execute(monthly_catchup_id: 3)

      expect(monthly_catchup[:id]).to eq(3)
      expect(monthly_catchup[:project_id]).to eq(7)
      expect(monthly_catchup[:data]).to eq({ cats: 'in hats'})
      expect(monthly_catchup[:status]).to eq('Submitted')
    end
  end
end
