require 'rspec'
require_relative '../shared_context/dependency_factory'
require_relative '../shared_context/project_fixtures'

describe 'Updating a HIF Project' do
  include_context 'dependency factory'
  include_context 'project fixtures'
  let(:time_now) { Time.now }

  before { Timecop.freeze(time_now) }

  after { Timecop.return }

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: 'cat project',
      type: 'hif',
      baseline: hif_mvf_core_project_baseline,
      bid_id: 'HIF/MV/5'
    )[:id]
  end

  def given_a_project
    project_id
  end

  def when_i_update_a_project
    get_use_case(:update_project).execute(project_id: project_id, project_data: { cats: 'meow' }, timestamp: 123)
  end

  def then_the_project_data_has_been_successfully_updated
    updated_project = get_use_case(:find_project).execute(id: project_id)

    expect(updated_project[:type]).to eq('hif')
    expect(updated_project[:data][:cats]).to eq('meow')
  end

  it 'Successfully updates a project' do
    given_a_project
    when_i_update_a_project
    then_the_project_data_has_been_successfully_updated
  end

  context 'updating an old version of the project data' do
    let(:project_id) do
      get_use_case(:create_new_project).execute(
        name: 'cat project',
        type: 'hif',
        baseline: hif_mvf_core_project_baseline,
        bid_id: 'AC/MV/5'
      )[:id]
    end

    def given_a_project
      project_id
    end

    def and_i_update_that_project
      get_use_case(:update_project).execute(project_id: project_id, project_data: { cats: 'meow' }, timestamp: time_now.to_i)
    end

    def when_i_update_the_project_with_a_timestamp_in_the_past
      get_use_case(:update_project).execute(project_id: project_id, project_data: { cats: 'meow' }, timestamp: time_now.to_i - 2000)
    end

    def then_the_project_data_will_not_be_updated
      updated_project = get_use_case(:find_project).execute(id: project_id)
      expect(updated_project[:data]).to eq({ cats: 'meow'})
    end

    it 'wont overwrite the more recent version of the project data' do
      given_a_project
      and_i_update_that_project
      when_i_update_the_project_with_a_timestamp_in_the_past
      then_the_project_data_will_not_be_updated
    end
  end
end
