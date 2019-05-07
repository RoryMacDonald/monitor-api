# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

fdescribe 'Creating a new project' do
  include_context 'dependency factory'

  let(:project_baseline) do
    {
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
  end

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: 'a project',
      type: 'hif',
      baseline: project_baseline,
      bid_id: 'HIF/MV/16'
    )[:id]
  end

  def given_a_project_baseline
    project_baseline
  end

  def when_we_create_a_new_project
    project_id
  end

  def then_the_project_can_be_found
    project = get_use_case(:find_project).execute(id: project_id)

    expect(project[:type]).to eq('hif')
    expect(project[:bid_id]).to eq('HIF/MV/16')
    expect(project[:version]).to eq(1)
    expect(project[:data][:summary]).to eq(project_baseline[:summary])
    expect(project[:data][:infrastructure]).to eq(project_baseline[:infrastructure])
    expect(project[:data][:financial]).to eq(project_baseline[:financial])
  end

  it 'Allows the user to create a new project' do
    given_a_project_baseline
    when_we_create_a_new_project
    then_the_project_can_be_found
  end

  context 'PCS' do
    let(:pcs_domain) { 'https://meow.cat' }
    let(:pcs_secret) { 'aoeaoe' }

    before do
      ENV['PCS'] = 'yes'
      ENV['PCS_SECRET'] = pcs_secret
      ENV['PCS_DOMAIN'] = pcs_domain
    end

    after do
      ENV['PCS'] = nil
      ENV['PCS_SECRET'] = nil
      ENV['PCS_DOMAIN'] = nil
    end

    let(:pcs_api_key) do
      Timecop.freeze(Time.now)
      current_time = Time.now.to_i
      thirty_days_in_seconds = 60 * 60 * 24 * 30
      thirty_days_from_now = current_time + thirty_days_in_seconds
      JWT.encode({ exp: thirty_days_from_now }, pcs_secret, 'HS512')
    end

    let(:project_id) do
      get_use_case(:create_new_project).execute(
        name: 'a new project',
        type: 'hif',
        baseline: project_baseline,
        bid_id: 'HIF/MV/6'
      )[:id]
    end

    let(:overview_data_request) do
      stub_request(
        :get, "#{pcs_domain}/pcs-api/v1/Projects/HIF%252FMV%252F6"
      ).to_return(
        status: 200,
        body: {
          ProjectManager: 'Jim',
          Sponsor: 'Euler'
        }.to_json
      ).with(
        headers: { 'Authorization' => "Bearer #{pcs_api_key}" }
      )
    end

    let(:actuals_data_request) do
      stub_request(
        :get, "#{pcs_domain}/pcs-api/v1/Projects/HIF%252FMV%252F6/actuals"
      ).to_return(
        status: 200,
        body: [{
          payments: {
            currentYearPayments:
              [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
          }
        }].to_json
      ).with(
        headers: { 'Authorization' => "Bearer #{pcs_api_key}" }
      )
    end

    let(:project) do
      get_use_case(:populate_baseline).execute(project_id: project_id)
    end

    def given_a_created_project
      project_id
    end

    def and_pcs_api_successfully_responds_to_requests
      overview_data_request
      actuals_data_request
    end

    def when_we_populate_the_baseline
      project
    end

    def then_data_requests_are_made_to_pcs_api
      expect(overview_data_request).to have_been_requested
      expect(actuals_data_request).to have_been_requested
    end

    def and_pcs_data_is_added_to_the_project_data
      expect(project[:data][:summary][:projectManager]).to eq('Jim')
      expect(project[:data][:summary][:sponsor]).to eq('Euler')
    end

    it 'Adds PCS data to data of a created project' do
      given_a_created_project
      and_pcs_api_successfully_responds_to_requests
      when_we_populate_the_baseline
      then_data_requests_are_made_to_pcs_api
      and_pcs_data_is_added_to_the_project_data
    end
  end
end
