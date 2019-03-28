# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Amending a project' do
  include_context 'dependency factory'

  let(:project_baseline) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'amends a project' do
    project_id = get_use_case(:create_new_project).execute(
      name: 'a project', type: 'hif', baseline: project_baseline, bid_id: 'HIF/MV/16'
    )[:id]

    response = get_use_case(:find_project).execute(id: project_id)
    get_use_case(:submit_project).execute(project_id: project_id)
    expect(response[:version]).to eq(1)

    id = get_use_case(:amend_baseline).execute(project_id: project_id)[:id]
    
    project = get_use_case(:find_project).execute(id: project_id)
    baselines = get_use_case(:get_baselines).execute(project_id: project_id)[:baselines]

    expect(project[:version]).to eq(1)
    expect(project[:status]).to eq('Submitted')
    expect(baselines.last[:version]).to eq(2)
    expect(baselines.last[:status]).to eq('Draft')

    get_use_case(:update_baseline).execute(
      project_id: project_id,
      project_data:
      {new_data: 'new baseline'},
      timestamp: 0
    )

    get_use_case(:submit_baseline).execute(id: id)

    project = get_use_case(:find_project).execute(id: project_id)

    baselines = get_use_case(:get_baselines).execute(project_id: project_id)[:baselines]

    expect(project[:version]).to eq(2)
    expect(project[:data]).to eq({new_data: 'new baseline'})
    expect(baselines.last[:status]).to eq('Submitted')
  end
end
