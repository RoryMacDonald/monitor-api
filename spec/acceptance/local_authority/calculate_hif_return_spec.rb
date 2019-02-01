# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Calculated return' do
  include_context 'dependency factory'

  it 'creates a return with calculated fields' do
    initial_return_input_data = {
      infrastructures: [
        {
          planning: {
            planningNotGranted: {
              fieldOne: {
                returnInput: {
                  currentReturn: '18/08/2000'
                }
              }
            }
          }
        }
      ],
      s151: {
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: '6',
            actual: '3',
          }
        }
      }
    }

    secondary_return_input_data = {
      infrastructures: [
        {
          planning: {
            planningNotGranted: {
              fieldOne: {
                returnInput: {
                  currentReturn: '25/08/2000'
                }
              }
            }
          }
        }
      ],
      s151: {
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: '6',
            actual: '3'
          }
        }
      }
    }

    expected_return_data = {
      infrastructures: [
        {
          planning: {
            planningNotGranted: {
              fieldOne: {
                returnInput: {
                  currentReturn: '25/08/2000'
                },
                varianceCalculations: {
                  varianceAgainstLastReturn: {
                    # Variance against Last Return submitted date (weeks)
                    varianceLastReturnFullPlanningPermissionSubmitted: '1'
                  }
                }
              }
            }
          }
        }
      ],
      s151: {
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: '6',
            actual: '3',
            hasVariance: 'Yes',
            varianceAgainstForcastAmount: '3',
            varianceAgainstForcastPercentage: '50'
          }
        }
      }
    }

    project_id = get_use_case(:create_new_project).execute(
      name: 'dog project 1',
      type: 'hif',
      baseline: {},
      bid_id: nil
    )[:id]

    return1_id = get_use_case(:create_return).execute(
      project_id: project_id,
      data: initial_return_input_data
    )[:id]

    get_use_case(:submit_return).execute(return_id: return1_id)

    return2_id = get_use_case(:create_return).execute(
      project_id: project_id,
      data: secondary_return_input_data
    )[:id]

    expected_return = {
      id: return2_id,
      type: 'hif',
      project_id: project_id,
      updates: [
        expected_return_data
      ],
      status: 'Draft',
      timestamp: 0
    }

    expect(get_use_case(:get_return).execute(id: return2_id)).to(
      eq(expected_return)
    )
  end
end
