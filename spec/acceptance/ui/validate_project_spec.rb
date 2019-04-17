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

      expect(validated_project[:invalid_paths][0]).to eq([:summary, :jointBidAuthorityAreas])
      expect(validated_project[:invalid_paths][1]).to eq([:summary, :sitePlans])
      expect(validated_project[:invalid_paths][2]).to eq([:infrastructures, 0, :summary, :expectedInfrastructureStart, :targetDateOfAchievingStartValidator])
      expect(validated_project[:invalid_paths][3]).to eq([:infrastructures, 0, :planningStatus, :planningStatus, :fullPlanningStatus, :granted])
      expect(validated_project[:invalid_paths][4]).to eq([:costs, 0, :infrastructure, :fundedThroughHif, :descriptionOfFundingStack])
      expect(validated_project[:invalid_paths][5]).to eq([:costs, 0, :infrastructure, :baselineCashflows])
      expect(validated_project[:invalid_paths][6]).to eq([:recovery, :expectedAmount])
      expect(validated_project[:invalid_paths][7]).to eq([:outputs])
      expect(validated_project[:invalid_paths][8]).to eq([:rmBaseline])
      expect(validated_project[:invalid_paths].length).to eq(9)

      expect(validated_project[:pretty_invalid_paths][0]).to eq(["HIF Project", "Project Summary", "Joint Bid Areas"])
      expect(validated_project[:pretty_invalid_paths][1]).to eq(["HIF Project", "Project Summary", "Site Plans"])
      expect(validated_project[:pretty_invalid_paths][2]).to eq(["HIF Project", "Infrastructures", "Infrastructure 1", "Summary", "Expected infrastructure start on site", ""])
      expect(validated_project[:pretty_invalid_paths][3]).to eq(["HIF Project", "Infrastructures", "Infrastructure 1", "Planning Status", "", "Full Planning Status", "Granted?"])
      expect(validated_project[:pretty_invalid_paths][4]).to eq(["HIF Project", "Costs", "Infrastructure 1", "Cost", "", "Description of Funding Stack"])
      expect(validated_project[:pretty_invalid_paths][5]).to eq(["HIF Project", "Costs", "Infrastructure 1", "Cost", "Baseline Cashflow(s)"])
      expect(validated_project[:pretty_invalid_paths][6]).to eq(["HIF Project", "Recovery", "Expected Amount"])
      expect(validated_project[:pretty_invalid_paths][7]).to eq(["HIF Project", "Outputs"])
      expect(validated_project[:pretty_invalid_paths][8]).to eq(["HIF Project", "RM Baseline"])
    end
  end
end
