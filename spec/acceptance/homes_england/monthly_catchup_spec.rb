require_relative '../shared_context/dependency_factory'

describe 'Monthly Catchup' do
  include_context 'dependency factory'

  it 'Creates, updates and submits an RM monthly_catchup' do
    project_baseline = {
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

    project = get_use_case(:create_new_project).execute(
      name: 'a project', type: 'hif', baseline: project_baseline, bid_id: 'HIF/MV/16'
    )

    monthly_catchup_id = get_use_case(:create_new_monthly_catchup).execute(project_id: project[:id], monthly_catchup_data: {
      date: '25/08/2000'
    })[:id]

    found_monthly_catchup = get_use_case(:get_monthly_catchup).execute(monthly_catchup_id: monthly_catchup_id)

    expect(found_monthly_catchup).to eq({
      id: monthly_catchup_id,
      project_id: project[:id],
      data: {
        date: '25/08/2000'
      },
      status: 'Draft'
    })

    get_use_case(:update_monthly_catchup).execute(
      monthly_catchup_id: monthly_catchup_id,
      monthly_catchup_data: { date: '01/01/1970' }
    )

    found_monthly_catchup = get_use_case(:get_monthly_catchup).execute(monthly_catchup_id: monthly_catchup_id)

    expect(found_monthly_catchup).to eq({
      id: monthly_catchup_id,
      project_id: project[:id],
      data: {
        date: '01/01/1970'
      },
      status: 'Draft'
    })

    get_use_case(:submit_monthly_catchup).execute(monthly_catchup_id: monthly_catchup_id)

    found_monthly_catchup = get_use_case(:get_monthly_catchup).execute(monthly_catchup_id: monthly_catchup_id)

    expect(found_monthly_catchup).to eq({
      id: monthly_catchup_id,
      project_id: project[:id],
      data: {
        date: '01/01/1970'
      },
      status: 'Submitted'
    })
  end
end
