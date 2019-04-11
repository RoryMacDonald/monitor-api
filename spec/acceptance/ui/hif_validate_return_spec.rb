# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF return' do
  include_context 'dependency factory'

  context 'Invalid HIF return' do
    # percent complete set to > 100
    let(:project_base_return_invalid) do
      File.open("#{__dir__}/../../fixtures/base_return.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    let(:valid_return) do
      File.open("#{__dir__}/../../fixtures/hif_mvf_valid_ui_return.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if fails validation' do
      allow(ENV).to receive(:[]).and_return(true)

      valid_return = get_use_case(:ui_validate_return).execute(type: 'hif', return_data: project_base_return_invalid)
      expect(valid_return[:valid]).to eq(false)
    end

    it 'Should return valid given valid data' do
      allow(ENV).to receive(:[]).and_return(true)

      valid_return = get_use_case(:ui_validate_return).execute(type: 'hif', return_data: valid_return)
      expect(valid_return[:valid]).to eq(true)
    end
  end
end
