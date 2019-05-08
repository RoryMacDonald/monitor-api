require_relative '../shared_context/dependency_factory'
require_relative '../shared_context/project_fixtures'

describe 'Getting the overview of a project' do
  include_context 'dependency factory'
  include_context 'project fixtures'

  let(:current_time) { Time.now }

  let(:created_project_id) do
    get_use_case(:create_new_project).execute(
      name: 'a project',
      type: 'hif',
      baseline: hif_mvf_core_project_baseline,
      bid_id: 'HIF/MV/16'
    )[:id]
  end

  let(:project_overview) { get_use_case(:get_project_overview).execute(id: created_project_id) }

  before do
    Timecop.freeze(current_time)
  end

  after do
    Timecop.return
  end

  context 'Given a newly created project' do
    def given_a_new_project
      created_project_id
    end

    def then_the_project_overview_describes_a_newly_created_project
      expect(project_overview[:name]).to eq('a project')
      expect(project_overview[:type]).to eq('hif')
      expect(project_overview[:status]).to eq('Draft')
      expect(project_overview[:data]).not_to be_nil
      expect(project_overview[:baselines].length).to eq(1)
      expect(project_overview[:returns]).to eq([])
      expect(project_overview[:claims]).to eq([])
    end

    it 'Gives the correct overview' do
      given_a_new_project
      then_the_project_overview_describes_a_newly_created_project
    end
  end

  context 'Given a submitted project with some data' do
    def create_new_return(project_id)
      get_use_case(:ui_create_return).execute(project_id: project_id, data: {})[:id]
    end

    def submit_return(return_id)
      get_use_case(:submit_return).execute(return_id: return_id)
    end

    def create_new_claim(project_id)
      get_use_case(:ui_create_claim).execute(
        project_id: project_id, claim_data: {}
      )[:claim_id]
    end

    let(:submitted_return_id) do
      return_id = create_new_return(created_project_id)
      submit_return(return_id)
      return_id
    end
    let(:draft_return_id) { create_new_return(created_project_id) }
    let(:claim_id) { create_new_claim(created_project_id) }
    def given_a_submitted_project
      created_project_id
    end

    def and_a_submitted_return
      submitted_return_id
    end

    def and_a_draft_return
      draft_return_id
    end

    def and_a_claim
      claim_id
    end

    def then_the_project_overview_describes_the_current_project
      expect(project_overview[:name]).to eq('a project')
      expect(project_overview[:type]).to eq('hif')
      expect(project_overview[:status]).to eq('Draft')
      expect(project_overview[:data]).not_to be_nil
      expect(project_overview[:baselines].length).to eq(1)

      expect(project_overview[:returns].length).to eq(2)
      expect(project_overview[:returns]).to(
        eq(
          [
            { id: submitted_return_id, status: 'Submitted', timestamp: current_time.to_i },
            { id: draft_return_id, status: 'Draft', timestamp: 0 }
          ]
        )
      )

      expect(project_overview[:claims].length).to eq(1)
      expect(project_overview[:claims]).to(
        eq(
          [
            { id: claim_id, status: 'Draft' },
          ]
        )
      )
    end

    it 'Gives the correct overview' do
      given_a_submitted_project
      and_a_submitted_return
      and_a_draft_return
      and_a_claim
      then_the_project_overview_describes_the_current_project
    end
  end
end
