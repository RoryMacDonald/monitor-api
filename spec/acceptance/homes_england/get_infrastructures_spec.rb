# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Gets the projects infrastructure' do
  include_context 'dependency factory'

  it 'gets the infrastructures' do
    project_baseline = {
      infrastructures: [
        {
          information: "words, words, words"
        },
        {
          information: "thirds, thirds, thirds"
        }
      ]
    }

    response = get_use_case(:create_new_project).execute(
      name: 'ff', type: 'ff', baseline: project_baseline, bid_id: 'FF/MV/16'
    )

    infrastructure_data = get_use_case(:get_infrastructures).execute(project_id: response[:id])

    expect(infrastructure_data).to eq(
      {
        infrastructures: [
          {
            information: "words, words, words"
          },
          {
            information: "thirds, thirds, thirds"
          }
        ]
      }
    )
  end
end
