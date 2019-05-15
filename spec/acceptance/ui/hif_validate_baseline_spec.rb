# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF Project' do
  include_context 'dependency factory'

  context 'Invalid HIF project' do
    let(:invalid_baseline) do
      File.open("#{__dir__}/../../fixtures/hif_baseline_missing_ui.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    let(:validated_project) do
      get_use_case(:ui_validate_project).execute(type: 'hif', project_data: invalid_baseline)
    end

    def given_an_invalid_project
      invalid_baseline
    end

    def when_validated
      validated_project
    end

    def then_the_correct_fields_are_marked_invalid
      invalid_path = [
        %i[summary sitePlans],
        [:infrastructures, 0, :planningStatus, :planningStatus, :fullPlanningStatus, :granted],
        [:costs, 0, :infrastructure, :fundedThroughHif, :descriptionOfFundingStack],
        [:costs, 0, :infrastructure, :baselineCashflows],
        %i[recovery expectedAmount],
        [:outputs],
        [:rmBaseline]
      ].freeze
      pretty_invalid_path = [
        ['HIF Project', 'Project Summary', 'Site Plans'],
        ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning Status', '', 'Full Planning Status', 'Granted?'],
        ['HIF Project', 'Costs', 'Infrastructure 1', 'Cost', '', 'Description of Funding Stack'],
        ['HIF Project', 'Costs', 'Infrastructure 1', 'Cost', 'Baseline Cashflow(s)'],
        ['HIF Project', 'Recovery', 'Expected Amount'],
        ['HIF Project', 'Outputs'],
        ['HIF Project', 'RM Baseline']
      ].freeze
      expect(validated_project[:valid]).to eq(false)
      expect(validated_project[:invalid_paths]).to eq(invalid_path)
      expect(validated_project[:pretty_invalid_paths]).to eq(pretty_invalid_path)
    end

    it 'should return invalid if fails validation' do
      given_an_invalid_project
      when_validated
      then_the_correct_fields_are_marked_invalid
    end
  end
end
