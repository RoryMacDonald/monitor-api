describe UI::UseCase::ConvertUIFFReturn do
  let(:core_data_return) do
    ff_return_core = File.open(
      "#{__dir__}/../../../fixtures/ff_return_core.json",
      &:read
    )

    JSON.parse(
      ff_return_core,
      symbolize_names: true
    )
  end

  let(:return_to_convert) do
    ff_return_ui = File.open(
      "#{__dir__}/../../../fixtures/ff_return_ui.json",
      &:read
    )
    
    JSON.parse(
      ff_return_ui,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(return_data: return_to_convert)

    expect(converted_project).to eq(core_data_return)
  end
end
