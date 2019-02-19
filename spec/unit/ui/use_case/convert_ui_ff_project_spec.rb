describe UI::UseCase::ConvertUIFFProject do
  let(:project_to_convert) do
    ff_baseline_ui = File.open(
      "#{__dir__}/../../../fixtures/ff_baseline_ui.json",
      &:read
    )

    JSON.parse(
      ff_baseline_ui,
      symbolize_names: true
    )
  end

  let(:core_data_project) do
    ff_baseline_core = File.open(
      "#{__dir__}/../../../fixtures/ff_baseline_core.json",
      &:read
    )
    
    JSON.parse(
      ff_baseline_core,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(project_data: project_to_convert)

    expect(converted_project).to eq(core_data_project)
  end
end
