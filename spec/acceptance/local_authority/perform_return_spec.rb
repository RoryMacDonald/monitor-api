# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Performing Return on HIF Project' do
  include_context 'dependency factory'

  let(:pcs_domain) { 'meow.cat' }
  let(:api_key) { 'C.B.R' }

  let(:project_baseline) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: '',
      type: 'hif',
      baseline: project_baseline,
      bid_id: 'HIF/MV/16'
    )[:id]
  end

  let(:expected_base_return) do
    File.open("#{__dir__}/../../fixtures/base_return.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:expected_second_base_return) do
    File.open("#{__dir__}/../../fixtures/second_base_return.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:initial_return) do
    {
      project_id: project_id,
      data: File.open("#{__dir__}/../../fixtures/hif_return_core.json") do |f|
              JSON.parse(
                f.read,
                symbolize_names: true
              )
            end
    }
  end

  let(:base_return) { get_use_case(:get_base_return).execute(project_id: project_id) }

  let(:return_id) do
    create_new_return(
      project_id: initial_return[:project_id],
      data: initial_return[:data]
    )
  end

  let(:expected_initial_return) do
    {
      baseline_version: 1,
      project_id: project_id,
      status: 'Draft',
      updates: [
        initial_return[:data]
      ]
    }
  end

  let(:updated_return_data) do
    File.open("#{__dir__}/../../fixtures/hif_updated_return_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:expected_updated_return) do
    {
      baseline_version: 1,
      project_id: project_id,
      status: 'Draft',
      updates: [
        initial_return[:data],
        updated_return_data,
        updated_return_data
      ]
    }
  end

  let(:first_return_data) { get_use_case(:get_return).execute(id: return_id) }
  let(:second_return_data) do
    second_return_id = create_new_return(project_id: project_id, data: initial_return[:data])
    get_use_case(:get_return).execute(id: second_return_id)
  end

  def get_return(id:)
    stub_request(:get, "http://#{pcs_domain}/project/#{id}").to_return(
      status: 200,
      body: {
        ProjectManager: 'Michael',
        Sponsor: 'MSPC'
      }.to_json
    ).with(
      headers: { 'Authorization' => "Bearer #{api_key}" }
    )

    get_use_case(:get_return).execute(id: id)
  end

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data[:data])
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end

  def create_new_return(return_data)
    get_use_case(:create_return).execute(return_data)[:id]
  end

  def soft_update_return(id:, data:)
    get_use_case(:soft_update_return).execute(return_id: id, return_data: data)
  end

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data)
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end

  def expect_return_with_id_to_equal(id:, expected_return:)
    found_return = get_return(id: id)
    expect(found_return[:data]).to eq(expected_return[:data])
    expect(found_return[:status]).to eq(expected_return[:status])
    expect(found_return[:updates]).to eq(expected_return[:updates])
  end

  def expect_return_to_be_submitted(id:)
    found_return = get_return(id: id)
    expect(found_return[:status]).to eq('Submitted')
  end

  before do
    ENV['PCS'] = 'yes'
    ENV['PCS_DOMAIN'] = pcs_domain
    ENV['PCS_SECRET'] = 'Secret 2'
    ENV['OUTPUTS_FORECAST_TAB'] = 'Yes'
    ENV['CONFIRMATION_TAB'] = 'Yes'
    ENV['S151_TAB'] = 'Yes'
    ENV['RM_MONTHLY_CATCHUP_TAB'] = 'Yes'
    ENV['MR_REVIEW_TAB'] = 'Yes'
    ENV['OUTPUTS_ACTUALS_TAB'] = 'Yes'
    ENV['HIF_RECOVERY_TAB'] = 'Yes'
  end

  after do
    ENV['OUTPUTS_FORECAST_TAB'] = nil
    ENV['CONFIRMATION_TAB'] = nil
    ENV['PCS_SECRET'] = nil
    ENV['S151_TAB'] = nil
    ENV['MR_REVIEW_TAB'] = nil
    ENV['OUTPUTS_ACTUALS_TAB'] = nil
    ENV['HIF_RECOVERY_TAB'] = nil
    ENV['PCS'] = nil
    ENV['PCS_DOMAIN'] = nil
  end

  def given_a_new_hif_project
    project_id
  end

  def given_a_hif_project_with_an_initial_return
    project_id
    return_id
  end

  def when_you_request_a_base_return
    base_return
  end

  def when_the_return_is_updated_twice
    soft_update_return(id: return_id, data: updated_return_data)
    soft_update_return(id: return_id, data: updated_return_data)
  end

  def when_the_return_is_submitted
    submit_return(id: return_id)
  end

  def when_i_amend_the_baseline
    first_return_data
    get_use_case(:amend_baseline).execute(project_id: project_id)
    second_return_data
  end

  def then_a_base_return_for_the_project_is_supplied
    expect(base_return[:base_return][:data]).to eq(expected_base_return)
  end

  def then_the_return_contains_past_updates
    expect_return_with_id_to_equal(
      id: return_id,
      expected_return: expected_updated_return
    )
  end

  def then_the_base_return_reflects_the_past_submitted_returns
    expect(base_return[:base_return][:data][:infrastructures]).to eq(expected_second_base_return[:infrastructures])
  end

  def then_the_versions_of_the_future_returns_are_increased
    expect(first_return_data[:baseline_version]).to eq(1)
    expect(second_return_data[:baseline_version]).to eq(2)
  end

  context 'Given a HIF project' do
    it 'can get a base return for a project' do
      given_a_new_hif_project
      when_you_request_a_base_return
      then_a_base_return_for_the_project_is_supplied
    end

    it 'can contain the past updates to returns' do
      given_a_hif_project_with_an_initial_return
      when_the_return_is_updated_twice
      then_the_return_contains_past_updates
    end

    it 'can keep track of returns' do
      given_a_hif_project_with_an_initial_return
      when_the_return_is_updated_twice
      when_the_return_is_submitted
      when_you_request_a_base_return
      then_the_base_return_reflects_the_past_submitted_returns
    end

    it 'can track new returns baseline version' do
      given_a_hif_project_with_an_initial_return
      when_i_amend_the_baseline
      then_the_versions_of_the_future_returns_are_increased
    end
  end

  context 'Given an LAAC project' do
    let(:ac_project_baseline) do
      File.open("#{__dir__}/../../fixtures/ac_baseline_core.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    let(:ac_project_id) do
      get_use_case(:create_new_project).execute(
        name: '',
        type: 'ac',
        baseline: ac_project_baseline,
        bid_id: 'AC/MV/6'
      )[:id]
    end

    let(:ac_base_return) { get_use_case(:get_base_return).execute(project_id: ac_project_id) }

    let(:expected_ac_base_return) do
      File.open("#{__dir__}/../../fixtures/ac_base_return.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    def given_a_new_ac_project
      ac_project_id
    end

    def when_you_request_an_ac_base_return
      ac_base_return
    end

    def then_the_ac_base_return_for_the_project_is_supplied
      expect(ac_base_return[:base_return][:data][:sites]).to eq(expected_ac_base_return[:sites])
    end

    it 'can keep track of LAAC Returns' do
      given_a_new_ac_project
      when_you_request_an_ac_base_return
      then_the_ac_base_return_for_the_project_is_supplied
    end
  end
end
