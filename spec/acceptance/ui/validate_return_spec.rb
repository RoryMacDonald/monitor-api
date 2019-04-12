# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF return' do
  include_context 'dependency factory'

  before do
    ENV['OUTPUTS_FORECAST_TAB'] = 'Yes'
    ENV['CONFIRMATION_TAB'] = 'Yes'
    ENV['S151_TAB'] = 'Yes'
    ENV['RM_MONTHLY_CATCHUP_TAB'] = 'Yes'
    ENV['MR_REVIEW_TAB'] = 'Yes'
    ENV['OUTPUTS_ACTUALS_TAB'] = 'Yes'
    ENV['HIF_RECOVERY_TAB'] = 'Yes'
    ENV['WIDER_SCHEME_TAB'] = 'Yes'
  end

  after do
    ENV['OUTPUTS_FORECAST_TAB'] = nil
    ENV['CONFIRMATION_TAB'] = nil
    ENV['S151_TAB'] = nil
    ENV['RM_MONTHLY_CATCHUP_TAB'] = nil
    ENV['MR_REVIEW_TAB'] = nil
    ENV['OUTPUTS_ACTUALS_TAB'] = nil
    ENV['HIF_RECOVERY_TAB'] = nil
    ENV['WIDER_SCHEME_TAB'] = nil
  end

  context 'Invalid HIF return' do
    let(:project_base_return) do
      File.open("#{__dir__}/../../fixtures/hif_saved_base_return_ui.json", 'r') do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if it fails validation' do
      validated_return = get_use_case(:ui_validate_return).execute(type: 'hif', return_data: project_base_return)

      expect(validated_return[:valid]).to eq(false)

      expect(validated_return[:invalid_paths][0]).to eq([:infrastructures, 0, :planning, :outlinePlanning, :planningSubmitted, :percentComplete])
      expect(validated_return[:invalid_paths][1]).to eq([:infrastructures, 0, :planning, :outlinePlanning, :planningGranted, :percentComplete])
      expect(validated_return[:invalid_paths].length).to eq(36)

      expect(validated_return[:pretty_invalid_paths][0]).to eq(["HIF Project", "Infrastructures", "Infrastructure 1", "Planning", "Outline Planning", "Planning Permission Submitted", "Percent Complete"])
      expect(validated_return[:pretty_invalid_paths][1]).to eq(["HIF Project", "Infrastructures", "Infrastructure 1", "Planning", "Outline Planning", "Planning Permission Granted", "Percent Complete"])
    end
  end
end
