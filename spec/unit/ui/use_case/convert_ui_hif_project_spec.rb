describe UI::UseCase::ConvertUIHIFProject do
  let(:project_to_convert) do
    File.open("#{__dir__}/../../../fixtures/hif_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:core_data_project) do
    File.open("#{__dir__}/../../../fixtures/hif_baseline_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(project_data: project_to_convert)

    expect(converted_project).to eq(core_data_project)
  end
end
