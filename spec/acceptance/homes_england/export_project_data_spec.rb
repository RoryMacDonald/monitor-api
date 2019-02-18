# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Compiles project data' do
  include_context 'dependency factory'

  def expected_compiled_project(project_id = nil, return_id = nil)
    {
      baseline: {
        name: 'project 1',
        monitor_project_id: project_id,
        type: 'hif',
        data: {
          summary: {
            project_name: 'Cats Protection League',
            description: 'A new headquarters for all the Cats',
            lead_authority: 'Made Tech'
          },
          infrastructure: {
            type: 'Cat Bathroom',
            description: 'Bathroom for Cats',
            completion_date: '2018-12-25',
            planning: {
              submission_estimated: '2018-01-01'
            }
          },
          financial: {
            total_amount_estimated: '£ 1,000,000.00'
          }
        }
      },
      submitted_returns: [
        {
          monitor_return_id: return_id,
          monitor_project_id: project_id,
          data: {
            summary: {
              project_name: 'Cats Protection League',
              description: 'A new headquarters for all the Cats',
              lead_authority: 'Made Tech'
            },
            infrastructures: [
              {
                type: 'Cat Bathroom',
                description: 'Bathroom for Cats',
                completion_date: '2018-12-25',
                planning: {
                  submission_estimated: '2018-06-01',
                  submission_actual: '2018-07-01',
                  submission_delay_reason: 'Planning office was closed for summer',
                  planningNotGranted: {
                    fieldOne: {
                      varianceCalculations: {
                        varianceAgainstLastReturn: {
                          varianceLastReturnFullPlanningPermissionSubmitted: nil
                        }
                      }
                    }
                  }
                }
              }
            ],
            financial: {
              total_amount_estimated: '£ 1000000.00',
              total_amount_actual: nil,
              total_amount_changed_reason: nil
            }
          }
        }
      ]
    }
  end

  it 'into a single hash' do
    project_baseline = expected_compiled_project[:baseline][:data]

    project_id = get_use_case(:create_new_project).execute(
      name: expected_compiled_project[:baseline][:name],
      type: expected_compiled_project[:baseline][:type],
      baseline: project_baseline,
      bid_id: 'HIF/MV/15'
    )[:id]

    get_use_case(:submit_project).execute(project_id: project_id)
    submitted_project = get_use_case(:find_project).execute(id: project_id)

    initial_return = expected_compiled_project[:submitted_returns][0]

    return_id = get_use_case(:create_return).execute(
      project_id: project_id,
      data: initial_return[:data]
    )[:id]

    get_use_case(:submit_return).execute(return_id: return_id)

    compiled_project = get_use_case(:export_project_data).execute(project_id: project_id)[:compiled_project]
    expect(compiled_project).to eq(expected_compiled_project(project_id, return_id))
  end

  it 'export multiple projects' do
    project_baseline = expected_compiled_project[:baseline][:data]
    project_id = get_use_case(:create_new_project).execute(
      name: expected_compiled_project[:baseline][:name],
      type: expected_compiled_project[:baseline][:type],
      baseline: project_baseline,
      bid_id: 'HIF/MV/15'
    )[:id]
    project_id_second = get_use_case(:create_new_project).execute(
      name: expected_compiled_project[:baseline][:name],
      type: expected_compiled_project[:baseline][:type],
      baseline: project_baseline,
      bid_id: 'HIF/MV/535'
    )[:id]

    get_use_case(:submit_project).execute(project_id: project_id)
    submitted_project = get_use_case(:find_project).execute(id: project_id)

    get_use_case(:submit_project).execute(project_id: project_id_second)
    submitted_project = get_use_case(:find_project).execute(id: project_id_second)

    initial_return = expected_compiled_project[:submitted_returns][0]

    return_id = get_use_case(:create_return).execute(
      project_id: project_id,
      data: initial_return[:data]
    )[:id]

    return_id_second = get_use_case(:create_return).execute(
      project_id: project_id_second,
      data: initial_return[:data]
    )[:id]

    get_use_case(:submit_return).execute(return_id: return_id)
    get_use_case(:submit_return).execute(return_id: return_id_second)

    compiled_project = get_use_case(:export_all_projects).execute()[:compiled_projects]
    expect(compiled_project).to eq([expected_compiled_project(project_id, return_id), expected_compiled_project(project_id_second, return_id_second)])
  end
end
