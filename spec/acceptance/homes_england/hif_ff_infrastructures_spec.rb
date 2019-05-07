# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'HIF Forward Funding Infrastructures' do
  include_context 'dependency factory'

  context 'Getting the infrastructures for a HIF Forward Funding project' do
    let(:project_baseline) do
      {
        infrastructures: {
          HIFFunded: [
            {
              information: 'words, words, words'
            },
            {
              information: 'thirds, thirds, thirds'
            }
          ]
        }
      }
    end

    let(:project_id) do
      get_use_case(:create_new_project).execute(
        name: 'ff', type: 'ff', baseline: project_baseline, bid_id: 'FF/MV/16'
      )[:id]
    end

    def given_a_hif_ff_project
      project_id
    end

    def then_i_can_get_the_infrastructures_for_the_project
      infrastructure_data = get_use_case(:get_infrastructures).execute(project_id: project_id)

      expect(infrastructure_data).to eq(
        infrastructures: {
          HIFFunded: [
            {
              information: 'words, words, words',
              type: 'hif',
              id: 1
            },
            {
              information: 'thirds, thirds, thirds',
              type: 'hif',
              id: 2
            }
          ]
        }
      )
    end

    it 'Allows the user to get the infrastructures for a project' do
      given_a_hif_ff_project
      then_i_can_get_the_infrastructures_for_the_project
    end
  end
end
