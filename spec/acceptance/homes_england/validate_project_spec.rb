# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF Project' do
  include_context 'dependency factory'

  context 'Invalid HIF project' do
    let(:invalid_project) do
      File.open("#{__dir__}/../../fixtures/hif_baseline_missing_core.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if fails validation' do
      valid_project = get_use_case(:validate_project).execute(type: 'hif', project_data: invalid_project)
      expect(valid_project[:valid]).to eq(false)
      expect(valid_project[:invalid_paths]).to eq([[:infrastructures, 0, :fullPlanningStatus, :granted ]])
      expect(valid_project[:pretty_invalid_paths]).to eq([['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Full Planning Status', 'Granted?']])
    end
  end
end
