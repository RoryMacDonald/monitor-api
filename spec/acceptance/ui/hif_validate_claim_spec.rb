describe 'validating a claim' do
  include_context 'dependency factory'

  it 'validates the claim' do
    response = get_use_case(:ui_validate_claim).execute(type: 'hif', claim_data: {})
    expect(response[:valid]).to eq(false)
    expect(response[:invalid_paths]).to eq([
        [:claimSummary],[:supportingEvidence]
      ]
    )
    expect(response[:invalid_pretty_paths]).to eq([
        ["Claim", "Summary of Claim"],
        ["Claim", "Supporting Evidence"]
      ]
    )
  end
end
