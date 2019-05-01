describe UI::UseCase::ConvertUiHifMonthlyCatchup do
  let(:monthly_catchup_to_convert) do
    {
      date: '01/01/1990'
    }
  end
  let(:core_data_monthly_catchup) do
    {
      date: '01/01/1990'
    }
  end
  let(:usecase) { described_class.new }

  it 'converts the UI data to core data' do
    expect(usecase.execute(monthly_catchup_data: monthly_catchup_to_convert)).to eq(core_data_monthly_catchup)
  end
end
