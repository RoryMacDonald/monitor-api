# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'
require_relative '../shared_context/project_fixtures'

fdescribe 'Creating a new project' do
  include_context 'dependency factory'
  include_context 'project fixtures'

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: 'a project',
      type: 'hif',
      baseline: hif_mvf_core_project_baseline,
      bid_id: 'HIF/MV/16'
    )[:id]
  end

  def given_a_project_baseline
    hif_mvf_core_project_baseline
  end

  def when_we_create_a_new_project
    project_id
  end

  def then_the_project_can_be_found_in_a_draft_state
    project = get_use_case(:find_project).execute(id: project_id)

    expect(project[:type]).to eq('hif')
    expect(project[:bid_id]).to eq('HIF/MV/16')
    expect(project[:version]).to eq(1)
    expect(project[:data][:summary]).to eq(hif_mvf_core_project_baseline[:summary])
    expect(project[:data][:infrastructure]).to eq(hif_mvf_core_project_baseline[:infrastructure])
    expect(project[:data][:financial]).to eq(hif_mvf_core_project_baseline[:financial])
  end

  it 'Allows the user to create a new project' do
    given_a_project_baseline
    when_we_create_a_new_project
    then_the_project_can_be_found_in_a_draft_state
  end
end
