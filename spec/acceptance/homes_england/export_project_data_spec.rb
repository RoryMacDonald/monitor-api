# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'
require_relative '../shared_context/project_fixtures'

describe 'Exporting project data' do
  include_context 'dependency factory'
  include_context 'project fixtures'

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

  context 'Exporting information about a single project' do
    let(:project_id) do
      project_baseline = expected_compiled_project[:baseline][:data]
      get_use_case(:create_new_project).execute(
        name: expected_compiled_project[:baseline][:name],
        type: expected_compiled_project[:baseline][:type],
        baseline: project_baseline,
        bid_id: 'HIF/MV/15'
      )[:id]
    end

    let(:return_id) do
      initial_return = expected_compiled_project[:submitted_returns][0]

      get_use_case(:create_return).execute(
        project_id: project_id,
        data: initial_return[:data]
      )[:id]
    end

    def given_a_submitted_project
      get_use_case(:submit_project).execute(project_id: project_id)
    end

    def and_a_submitted_return
      get_use_case(:submit_return).execute(return_id: return_id)
    end

    def then_the_exported_project_contains_the_baseline_and_submitted_return
      compiled_project = get_use_case(:export_project_data).execute(project_id: project_id)[:compiled_project]
      expect(compiled_project).to eq(expected_compiled_project(project_id, return_id))
    end

    it 'Exports the project with its submitted returns' do
      given_a_submitted_project
      and_a_submitted_return
      then_the_exported_project_contains_the_baseline_and_submitted_return
    end
  end

  context 'Exporting information about all projects' do
    let(:project_baseline) { expected_compiled_project[:baseline][:data] }
    let(:first_project_id) do
      get_use_case(:create_new_project).execute(
        name: expected_compiled_project[:baseline][:name],
        type: expected_compiled_project[:baseline][:type],
        baseline: project_baseline,
        bid_id: 'HIF/MV/15'
      )[:id]
    end
    let(:second_project_id) do
      get_use_case(:create_new_project).execute(
        name: expected_compiled_project[:baseline][:name],
        type: expected_compiled_project[:baseline][:type],
        baseline: project_baseline,
        bid_id: 'HIF/MV/535'
      )[:id]
    end

    let(:initial_return) { expected_compiled_project[:submitted_returns][0] }
    let(:first_return_id) do
      get_use_case(:create_return).execute(
        project_id: first_project_id,
        data: initial_return[:data]
      )[:id]
    end
    let(:second_return_id) do
      get_use_case(:create_return).execute(
        project_id: second_project_id,
        data: initial_return[:data]
      )[:id]
    end

    def given_multiple_submitted_projects
      get_use_case(:submit_project).execute(project_id: first_project_id)
      get_use_case(:submit_project).execute(project_id: second_project_id)
    end

    def and_submitted_returns
      get_use_case(:submit_return).execute(return_id: first_return_id)
      get_use_case(:submit_return).execute(return_id: second_return_id)
    end

    def then_both_projects_are_exported_with_their_returns
      compiled_project = get_use_case(:export_all_projects).execute[:compiled_projects]
      expect(compiled_project).to eq(
        [
          expected_compiled_project(first_project_id, first_return_id),
          expected_compiled_project(second_project_id, second_return_id)
        ]
      )
    end

    it 'Exports all projects and their submitted returns' do
      given_multiple_submitted_projects
      and_submitted_returns
      then_both_projects_are_exported_with_their_returns
    end
  end
end
