# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF return' do
  include_context 'dependency factory'

  context 'Invalid HIF return' do
    # percent complete set to > 100
    let(:project_base_return) do
      File.open("#{__dir__}/../../fixtures/base_return.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if it fails validation' do
      valid_return = get_use_case(:validate_return).execute(type: 'hif', return_data: project_base_return)
      expect(valid_return[:valid]).to eq(false)
      expect(valid_return[:invalid_paths]).to eq([
        [:infrastructures, 0, :planning, :outlinePlanning, :planningSubmitted, :percentComplete]
      ])
      expect(valid_return[:pretty_invalid_paths]).to eq([
        ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning', 'Outline Planning', 'Planning Permission Submitted', 'Percent Complete']
      ])
    end
  end
end
