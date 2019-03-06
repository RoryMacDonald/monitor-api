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

    get_use_case(:amend_baseline).execute(project_id: project_id, data: {}, timestamp: 0)

    response = get_use_case(:find_project).execute(id: project_id)
    expect(response[:version]).to eq(2)
  end
end