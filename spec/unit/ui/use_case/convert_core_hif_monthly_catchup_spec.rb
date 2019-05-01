describe UI::UseCase::ConvertCoreHifMonthlyCatchup do
  let(:monthly_catchup_to_convert) do
    {
      date: '01/01/1990'
    }
  end
  let(:ui_data_monthly_catchup) do
    {
      date: '01/01/1990'
    }
  end
  let(:usecase) { described_class.new }

  it 'converts the core data to UI data' do
    expect(usecase.execute(monthly_catchup_data: monthly_catchup_to_convert)).to eq(ui_data_monthly_catchup)
  end
end
