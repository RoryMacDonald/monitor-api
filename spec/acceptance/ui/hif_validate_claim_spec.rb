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
      expect(response[:valid]).to eq(false)
      expect(response[:invalid_paths].count).to eq(2)
    end
  end
end
