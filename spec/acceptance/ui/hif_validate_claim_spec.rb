# frozen_string_literal: true

describe 'validating a claim' do
  include_context 'dependency factory'

  context 'Invalid FF project' do
    let(:invalid_project) do
      File.open("#{__dir__}/../../fixtures/claim_missing_ui.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if it fails validation' do
      response = get_use_case(:ui_validate_claim).execute(type: 'hif', claim_data: invalid_project)
      INVALID_PATH = [
        %i[claimSummary AmountOfThisClaim]
      ].freeze
      PRETTY_INVALID_PATH = [
        ['s151 Return - Claim', 'Summary of Claim', 'Amount of this Claim']
      ].freeze
      expect(response[:valid]).to eq(false)
      expect(response[:invalid_paths]).to eq(INVALID_PATH)
      expect(response[:pretty_invalid_paths]).to eq(PRETTY_INVALID_PATH)
    end
  end
end
