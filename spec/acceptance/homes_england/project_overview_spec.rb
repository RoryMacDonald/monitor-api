require_relative '../shared_context/dependency_factory'

describe 'Getting the overview of a project' do
  include_context "dependency factory"

  let(:current_time) { Time.now }

  let(:fixture_directory) { "#{__dir__}/../../fixtures" }

  let(:get_project_overview) { get_use_case(:get_project_overview) }

  let(:created_project_id) do
    get_use_case(:ui_create_project).execute(
      name: 'a project', type: 'ac', baseline: nil, bid_id: 'HIF/MV/16'
    )[:id]
  end

  let(:project_overview) { get_project_overview.execute(id: created_project_id) }

  before do
    Timecop.freeze(current_time)
  end

  after do
    Timecop.return
  end

  context 'A newly created project' do
    it 'Gives the correct overview' do
      expect(project_overview[:name]).to eq('a project')
      expect(project_overview[:type]).to eq('ac')
      expect(project_overview[:status]).to eq('Draft')
      expect(project_overview[:data]).not_to be_nil
      expect(project_overview[:baselines].length).to eq(1)
      expect(project_overview[:returns]).to eq([])
      expect(project_overview[:claims]).to eq([])
    end
  end

  context 'Given a submitted project with some data' do
    before { created_project_id }

    it 'Gives the correct overview' do
      return_one_id = create_new_return(created_project_id)
      return_two_id = create_new_return(created_project_id)

      submit_return(return_one_id)

      claim_id = create_new_claim(created_project_id)

      expect(project_overview[:name]).to eq('a project')
      expect(project_overview[:type]).to eq('ac')
      expect(project_overview[:status]).to eq('Draft')
      expect(project_overview[:data]).not_to be_nil
      expect(project_overview[:baselines].length).to eq(1)

      expect(project_overview[:returns].length).to eq(2)
      expect(project_overview[:returns]).to(
        eq(
          [
            { id: return_one_id, status: 'Submitted', timestamp: current_time.to_i },
            { id: return_two_id, status: 'Draft', timestamp: 0 }
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
  end

  private

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
end
