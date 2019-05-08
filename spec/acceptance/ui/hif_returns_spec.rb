# frozen_string_literal: true

require_relative '../shared_context/dependency_factory'

describe 'Interacting with a HIF Return from the UI' do
  include_context 'dependency factory'

  let(:pcs_domain) { 'https://meow.cat' }
  let(:pcs_secret) { 'Secret' }
  let(:pcs_api_key) do
    Timecop.freeze(Time.now)
    current_time = Time.now.to_i
    thirty_days_in_seconds = 60 * 60 * 24 * 30
    thirty_days_from_now = current_time + thirty_days_in_seconds
    JWT.encode({ exp: thirty_days_from_now }, pcs_secret, 'HS512')
  end

  let(:project_id) { create_project }
  let(:hif_baseline) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:hif_get_return) do
    File.open("#{__dir__}/../../fixtures/hif_saved_base_return_ui.json", 'r') do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:expected_updated_return) do
    File.open("#{__dir__}/../../fixtures/hif_updated_return_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:full_return_data) do
    File.open("#{__dir__}/../../fixtures/hif_return_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:full_return_data_after_calcs) do
    File.open("#{__dir__}/../../fixtures/hif_return_ui_after_calcs.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:return_id) { get_use_case(:ui_create_return).execute(project_id: project_id, data: return_data)[:id] }

  let(:return_data) do
    return_data = get_base_return_data
    return_data[:infrastructures][0][:planning][:outlinePlanning][:planningSubmitted][:status] = 'Delayed'
    return_data[:infrastructures][0][:planning][:outlinePlanning][:planningSubmitted][:reason] = 'Distracted by kittens'
    return_data[:s151Confirmation][:hifFunding][:hifTotalFundingRequest] = '10000'
    return_data[:s151] = {
      claimSummary: {
        hifTotalFundingRequest: '10000',
        hifSpendToDate: nil,
        AmountOfThisClaim: nil
      }
    }
    return_data
  end

  before do
    ENV['PCS'] = 'yes'
    ENV['PCS_DOMAIN'] = pcs_domain
    ENV['PCS_SECRET'] = pcs_secret

    ENV['OUTPUTS_FORECAST_TAB'] = 'Yes'
    ENV['CONFIRMATION_TAB'] = 'Yes'
    ENV['S151_TAB'] = 'Yes'
    ENV['RM_MONTHLY_CATCHUP_TAB'] = 'Yes'
    ENV['MR_REVIEW_TAB'] = 'Yes'
    ENV['OUTPUTS_ACTUALS_TAB'] = 'Yes'
    ENV['HIF_RECOVERY_TAB'] = 'Yes'

    setup_pcs_api_endpoints
  end

  after do
    ENV['PCS'] = nil
    ENV['PCS_DOMAIN'] = nil
    ENV['PCS_SECRET'] = nil

    ENV['OUTPUTS_FORECAST_TAB'] = nil
    ENV['CONFIRMATION_TAB'] = nil
    ENV['S151_TAB'] = nil
    ENV['RM_MONTHLY_CATCHUP_TAB'] = nil
    ENV['MR_REVIEW_TAB'] = nil
    ENV['OUTPUTS_ACTUALS_TAB'] = nil
    ENV['HIF_RECOVERY_TAB'] = nil
  end

  def setup_pcs_api_endpoints
    stub_request(
      :get, "#{pcs_domain}/pcs-api/v1/Projects/HIF%252FMV%252F757"
    ).to_return(
      status: 200,
      body: {
        "projectManager": 'Max Stevens',
        "sponsor": 'Timothy Turner'
      }.to_json
    ).with(
      headers: { 'Authorization' => "Bearer #{pcs_api_key}" }
    )

    stub_request(
      :get, "#{pcs_domain}/pcs-api/v1/Projects/HIF%252FMV%252F757/actuals"
    ).to_return(
      status: 200,
      body: [
        {
          payments: {
            currentYearPayments:
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
          }
        }
      ].to_json
    ).with(
      headers: { 'Authorization' => "Bearer #{pcs_api_key}" }
    )
  end

  def create_project
    dependency_factory.get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: hif_baseline,
      bid_id: 'HIF/MV/757'
    )[:id]
  end

  def get_base_return_data
    get_use_case(:ui_get_base_return).execute(project_id: project_id)[:base_return][:data].dup
  end

  context 'Creating returns' do
    let(:full_data_return_id) do
      get_use_case(:ui_create_return).execute(project_id: project_id, data: full_return_data)[:id]
    end

    def given_a_new_project
      project_id
    end

    def when_the_user_creates_a_return
      return_id
    end

    def when_the_user_creates_a_return_with_full_data
      full_data_return_id
    end

    def when_the_user_creates_multiple_returns
      get_use_case(:ui_create_return).execute(project_id: project_id, data: get_base_return_data)[:id]
      get_use_case(:ui_create_return).execute(project_id: project_id, data: get_base_return_data)[:id]
    end

    def then_the_user_can_view_the_new_return
      created_return = get_use_case(:ui_get_return).execute(id: return_id)[:updates].last
      expect(created_return[:outputsForecast]).to eq(expected_updated_return[:outputsForecast])
    end

    def then_the_user_can_view_the_full_data_return
      created_return = get_use_case(:ui_get_return).execute(id: full_data_return_id)[:updates].last
      expect(created_return).to eq(full_return_data_after_calcs)
    end

    def then_the_user_can_view_all_the_returns
      created_returns = get_use_case(:ui_get_returns).execute(project_id: project_id)[:returns]

      created_return_one = created_returns[0][:updates][0]
      created_return_two = created_returns[1][:updates][0]

      expect(created_return_one).to eq(hif_get_return)
      expect(created_return_two).to eq(hif_get_return)
    end

    it 'Allows the user to create and view a return' do
      given_a_new_project
      when_the_user_creates_a_return
      then_the_user_can_view_the_new_return
    end

    it 'Allows the user to create a return with all the data in' do
      given_a_new_project
      when_the_user_creates_a_return_with_full_data
      then_the_user_can_view_the_full_data_return
    end

    it 'Allows the user to view multiple created returns' do
      given_a_new_project
      when_the_user_creates_multiple_returns
      then_the_user_can_view_all_the_returns
    end
  end

  context 'Updating returns' do
    def given_a_project_with_an_existing_return
      project_id
      return_id
    end

    def when_the_user_updates_the_return
      get_use_case(:ui_update_return).execute(return_id: return_id, return_data: return_data)
    end

    def then_the_user_can_view_the_updated_return
      created_return = get_use_case(:ui_get_return).execute(id: return_id)[:updates].last
      expect(created_return[:outputsForecast]).to eq(expected_updated_return[:outputsForecast])
    end

    it 'Allows the user to update a return' do
      given_a_project_with_an_existing_return
      when_the_user_updates_the_return
      then_the_user_can_view_the_updated_return
    end
  end
end
