# frozen_string_literal: true

describe 'validating a claim' do
  include_context 'dependency factory'

  context 'Invalid HIF claim' do
    let(:invalid_claim) do
      File.open("#{__dir__}/../../fixtures/claim_missing_ui.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    def given_an_invalid_claim
      invalid_claim
    end

    def then_the_claim_should_fail_validation
      response = get_use_case(:ui_validate_claim).execute(type: 'hif', claim_data: invalid_claim)
      expect(response[:valid]).to eq(false)
      expect(response[:invalid_paths].count).to eq(2)
    end

    it 'should fail validation' do
      given_an_invalid_claim
      then_the_claim_should_fail_validation
    end
  end
end
