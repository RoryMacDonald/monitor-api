describe HomesEngland::UseCase::SubmitMonthlyCatchup do
  let(:monthly_catchup_gateway) { spy }

  context 'calls submit on the monthly_catchup gateway' do
    example 1 do
      described_class.new(monthly_catchup_gateway: monthly_catchup_gateway).execute(monthly_catchup_id: 22)
      expect(monthly_catchup_gateway).to have_received(:submit).with(id: 22)
    end

    example 2 do
      described_class.new(monthly_catchup_gateway: monthly_catchup_gateway).execute(monthly_catchup_id: 33)
      expect(monthly_catchup_gateway).to have_received(:submit).with(id: 33)
    end
  end
end
