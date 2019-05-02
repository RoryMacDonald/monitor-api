require_relative '../shared_context/dependency_factory'

fdescribe 'Monthly Catchup Converting' do
  include_context 'dependency factory'
  let(:schema) do
    File.open("#{__dir__}/../../../lib/ui/gateway/schemas/monthly_catchup/hif.json", 'r') do |f|
      return JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'creates and updates a monthly_catchup from ui data' do
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

    base_monthly_catchup = get_use_case(:ui_get_base_monthly_catchup).execute(type: 'hif')

    expect(base_monthly_catchup).to eq({
      project_id: project[:id],
      data: {},
      schema: schema
    })

    monthly_catchup_id = get_use_case(:ui_create_monthly_catchup).execute(project_id: project[:id], monthly_catchup_data: {
      date: "25/08/2000"
    })[:id]

    found_monthly_catchup = get_use_case(:ui_get_monthly_catchup).execute(project_id: project[:id], monthly_catchup_id: monthly_catchup_id)

    expect(found_monthly_catchup).to eq({
      id: monthly_catchup_id,
      project_id: project[:id],
      data: {
        date: "25/08/2000"
      },
      status: 'Draft',
      schema: schema
    })

    get_use_case(:ui_update_monthly_catchup).execute(project_id: project[:id], monthly_catchup_id: monthly_catchup_id, monthly_catchup_data: { date: '17/12/1998' })

    found_monthly_catchup = get_use_case(:ui_get_monthly_catchup).execute(project_id: project[:id], monthly_catchup_id: monthly_catchup_id)

    expect(found_monthly_catchup).to eq({
      id: monthly_catchup_id,
      project_id: project[:id],
      data: {
        date: '17/12/1998'
      },
      status: 'Draft',
      schema: schema
    })
  end
end
