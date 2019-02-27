describe UI::UseCase::ConvertCoreACClaim do
  let(:core_claim_to_convert) do
    File.open("#{__dir__}/../../../fixtures/ac_claim_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:ui_data_claim) do
    File.open("#{__dir__}/../../../fixtures/ac_claim_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Converts the core claim into a ui claim correctly' do
    converted_claim = described_class.new.execute(claim_data: core_claim_to_convert)

    expect(converted_claim).to eq(ui_data_claim)
  end
end
