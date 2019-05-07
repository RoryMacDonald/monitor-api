require_relative '../shared_context/dependency_factory'
require_relative '../shared_context/project_fixtures'

fdescribe 'PCS integration with HIF MVF' do
  include_context 'dependency factory'
  include_context 'project fixtures'

  context 'Integration with baseline' do
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
        baseline: hif_mvf_core_project_baseline,
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

  context 'Integration with claims' do
    #TODO
  end

  context 'Integration with returns' do
    #TODO
  end
end
