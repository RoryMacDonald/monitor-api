require 'rspec'
require_relative '../shared_context/dependency_factory'
require 'timecop'

describe 'Getting multiple returns' do
  include_context 'dependency factory'

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: 'cat hif project',
      type: 'hif',
      baseline: {},
      bid_id: nil
    )[:id]
  end

  let(:return1_id) do
    get_use_case(:create_return).execute(
      project_id: project_id, data: { cats: 'meow' }
    )[:id]
  end

  let(:return2_id) do
    get_use_case(:create_return).execute(
      project_id: project_id, data: { dogs: 'woof' }
    )[:id]
  end

  def given_a_project_with_two_returns
    get_use_case(:submit_return).execute(return_id: return1_id)
    return2_id
  end

  def freeze_time_to_current_time()
    time_now = Time.now
    Timecop.freeze(time_now)
    time_now
  end

  let(:frozen_time) do
    freeze_time_to_current_time.to_i
  end

  let(:returns_for_project) { get_use_case(:get_returns).execute(project_id: project_id) }

  def when_getting_returns_for_the_project
    frozen_time
    returns_for_project
  end

  def then_all_returns_are_provided
    expected_returns = [
      {
        id: return1_id,
        project_id: project_id,
        updates: [
          { cats: 'meow' }
        ],
        status: 'Submitted',
        timestamp: frozen_time
      },
      {
        id: return2_id,
        project_id: project_id,
        updates: [
          { dogs: 'woof' }
        ],
        status: 'Draft',
        timestamp: 0
      }
    ]

    expect(returns_for_project[:returns]).to(
      eq(expected_returns)
    )
  end

  it 'can get multiple returns by project id from a gateway' do
    given_a_project_with_two_returns
    when_getting_returns_for_the_project
    then_all_returns_are_provided
  end
end
