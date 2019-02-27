describe UI::UseCase::ConvertUIFFClaim do
  let(:claim_to_convert) do
    ff_claim_ui = File.open(
      "#{__dir__}/../../../fixtures/ff_claim_ui.json",
      &:read
    )

    JSON.parse(
      ff_claim_ui,
      symbolize_names: true
    )
  end

  let(:core_data_claim) do
    ff_claim_core = File.open(
      "#{__dir__}/../../../fixtures/ff_claim_core.json",
      &:read
    )

    JSON.parse(
      ff_claim_core,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(claim_data: claim_to_convert)

    expect(converted_project).to eq(core_data_claim)
  end
end
