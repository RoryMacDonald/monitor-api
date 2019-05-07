# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'
require_relative '../shared_context/project_fixtures'

describe 'Submitting a completed draft project' do
  include_context 'dependency factory'
  include_context 'project fixtures'

  context 'Submitting a draft project' do
    let(:project_id) do
      get_use_case(:create_new_project).execute(
        name: 'cat project',
        type: 'hif',
        baseline: hif_mvf_core_project_baseline,
        bid_id: 'HIF/MV/151'
      )[:id]
    end

    let(:submitted_project) { get_use_case(:find_project).execute(id: project_id) }

    def given_a_draft_project
      project_id
      get_use_case(:submit_project).execute(project_id: project_id)
      submitted_project
    end

    def then_the_project_is_submitted
      expect(submitted_project[:status]).to eq('Submitted')
    end

    it 'Changes the status to submitted' do
      given_a_draft_project
      then_the_project_is_submitted
    end
  end
end
