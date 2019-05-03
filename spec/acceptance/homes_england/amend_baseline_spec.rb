# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Creating a new baseline amendment' do
  include_context 'dependency factory'

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: 'a project', type: 'hif', baseline: project_baseline, bid_id: 'HIF/MV/16'
    )[:id]
  end

  let(:project) do
    get_use_case(:find_project).execute(id: project_id)
  end

  let(:amendment_id) do
    get_use_case(:amend_baseline).execute(project_id: project_id)[:id]
  end

  def given_a_submitted_project
    get_use_case(:submit_project).execute(project_id: project_id)
  end

  def when_we_create_a_new_draft_amendment
    amendment_id
  end

  def then_the_project_has_an_additional_draft_baseline
    baselines = get_use_case(:get_baselines).execute(project_id: project_id)[:baselines]

    expect(baselines[0][:version]).to eq(1)
    expect(baselines[1][:version]).to eq(2)

    expect(baselines[0][:status]).to eq('Submitted')
    expect(baselines[1][:status]).to eq('Draft')

    expect(baselines[0][:data]).to eq(baselines[1][:data])
  end

  def and_we_update_the_draft_amendment
    get_use_case(:update_project).execute(
      project_id: project_id,
      project_data: { new_data: 'new baseline' },
      timestamp: 0
    )
  end

  def and_we_submit_the_amendment
    get_use_case(:submit_baseline).execute(id: amendment_id)
  end

  def then_the_project_baseline_is_now_the_latest_amendment
    project = get_use_case(:find_project).execute(id: project_id)

    baselines = get_use_case(:get_baselines).execute(project_id: project_id)[:baselines]

    expect(project[:version]).to eq(2)
    expect(project[:data]).to eq({ new_data: 'new baseline' })
    expect(baselines.last[:status]).to eq('Submitted')
  end

  let(:project_baseline) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Allows the user to create a new amendment to the baseline to be edited' do
    given_a_submitted_project
    when_we_create_a_new_draft_amendment
    then_the_project_has_an_additional_draft_baseline
  end

  it 'Allows the user to submit the amendment to create a new baseline' do
    given_a_submitted_project
    when_we_create_a_new_draft_amendment
    and_we_update_the_draft_amendment
    and_we_submit_the_amendment
    then_the_project_baseline_is_now_the_latest_amendment
  end
end
