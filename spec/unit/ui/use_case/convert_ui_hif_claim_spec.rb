describe UI::UseCase::ConvertUIHIFClaim do
  let(:claim_to_convert) do
    File.open("#{__dir__}/../../../fixtures/hif_claim_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:core_data_claim) do
    File.open("#{__dir__}/../../../fixtures/hif_claim_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Converts the claim correctly' do
    converted_claim = described_class.new.execute(claim_data: claim_to_convert)

    expect(converted_claim).to eq(core_data_claim)
  end
end
