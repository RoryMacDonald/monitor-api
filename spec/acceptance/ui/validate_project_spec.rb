# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF Project' do
  include_context 'dependency factory'

  context 'Invalid HIF project' do
    let(:invalid_project) do
      File.open("#{__dir__}/../../fixtures/hif_baseline_missing_ui.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if fails validation' do
      validated_project = get_use_case(:ui_validate_project).execute(type: 'hif', project_data: invalid_project)
      expect(validated_project[:valid]).to eq(false)

      expect(validated_project[:invalid_paths]).to eq([
        [:summary, :sitePlans],
        [:infrastructures, 0, :planningStatus, :planningStatus, :fullPlanningStatus, :granted],
        [:costs, 0, :infrastructure, :fundedThroughHif, :descriptionOfFundingStack],
        [:costs, 0, :infrastructure, :baselineCashflows],
        [:recovery, :expectedAmount],
        [:outputs],
        [:rmBaseline]
      ])

      expect(validated_project[:pretty_invalid_paths]).to eq([
        ['HIF Project', 'Project Summary', 'Site Plans'],
        ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning Status', '', 'Full Planning Status', 'Granted?'],
        ['HIF Project', 'Costs', 'Infrastructure 1', 'Cost', '', 'Description of Funding Stack'],
        ['HIF Project', 'Costs', 'Infrastructure 1', 'Cost', 'Baseline Cashflow(s)'],
        ['HIF Project', 'Recovery', 'Expected Amount'],
        ['HIF Project', 'Outputs'],
        ['HIF Project', 'RM Baseline']
      ])
    end
  end
end
