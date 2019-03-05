# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Creating a new HIF FileProject' do
  include_context 'dependency factory'

  it 'should save project and return a unique id' do
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

    response = get_use_case(:create_new_project).execute(
      name: 'a project', type: 'hif', baseline: project_baseline, bid_id: 'HIF/MV/16'
    )

    project = get_use_case(:find_project).execute(id: response[:id])

    expect(project[:type]).to eq('hif')
    expect(project[:bid_id]).to eq('HIF/MV/16')
    expect(project[:version]).to eq(1)
    expect(project[:data][:summary]).to eq(project_baseline[:summary])
    expect(project[:data][:infrastructure]).to eq(project_baseline[:infrastructure])
    expect(project[:data][:financial]).to eq(project_baseline[:financial])
  end

  it 'should have an initial status of draft' do
    project_baseline = {
      summary: {
        project_name: '',
        description: '',
        lead_authority: ''
      },
      infrastructure: {
        type: '',
        description: '',
        completion_date: '',
        planning: {
          submission_estimated: ''
        }
      },
      financial: {
        total_amount_estimated: ''
      }
    }
    response = get_use_case(:create_new_project).execute(
      name: 'a new project', type: 'hif', baseline: project_baseline, bid_id: 'HIF/MV/15'
    )
    project = get_use_case(:find_project).execute(id: response[:id])
    expect(project[:status]).to eq('Draft')
  end

  context 'PCS' do
    let(:pcs_domain) { 'https://meow.cat' }

    before do
      ENV['PCS'] = 'yes'
      ENV['PCS_SECRET'] = 'aoeaoe'
      ENV['PCS_DOMAIN'] = pcs_domain
    end

    after do
      ENV['PCS'] = nil
      ENV['PCS_SECRET'] = nil
      ENV['PCS_DOMAIN'] = nil
    end

    it 'should get pcs data' do
      project_baseline = {
        summary: {
          project_name: '',
          description: '',
          lead_authority: ''
        },
        infrastructure: {
          type: '',
          description: '',
          completion_date: '',
          planning: {
            submission_estimated: ''
          }
        },
        financial: {
          total_amount_estimated: ''
        }
      }
      response = get_use_case(:create_new_project).execute(
        name: 'a new project', type: 'hif', baseline: project_baseline, bid_id: 'HIF/MV/6'
      )

      overview_data_request = stub_request(
        :get, "#{pcs_domain}/pcs-api/v1/Projects/HIF%252FMV%252F6"
      ).to_return(
        status: 200,
        body: {
          ProjectManager: 'Jim',
          Sponsor: 'Euler'
        }.to_json
      ).with(
        headers: {'Authorization' => "Bearer #{JWT.encode({}, 'aoeaoe', 'HS512')}" }
      )
      actuals_data_request = stub_request(
        :get, "#{pcs_domain}/pcs-api/v1/Projects/HIF%252FMV%252F6/actuals"
      ).to_return(
        status: 200,
        body: [
          {
            payments: {
              currentYearPayments:
              [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
            }
          }
        ].to_json
      ).with(
        headers: {'Authorization' => "Bearer #{JWT.encode({}, 'aoeaoe', 'HS512')}" }
      )

      project = get_use_case(:populate_baseline).execute(project_id: response[:id])

      expect(overview_data_request).to have_been_requested
      expect(actuals_data_request).to have_been_requested
      expect(project[:data][:summary][:projectManager]).to eq('Jim')
      expect(project[:data][:summary][:sponsor]).to eq('Euler')
    end
  end
end
