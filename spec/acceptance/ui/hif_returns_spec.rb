# frozen_string_literal: true
require_relative '../shared_context/dependency_factory'

describe 'Interacting with a HIF Return from the UI' do
  include_context 'dependency factory'

  before do
    ENV['OUTPUTS_FORECAST_TAB'] = 'Yes'
    ENV['CONFIRMATION_TAB'] = 'Yes'
    ENV['S151_TAB'] = 'Yes'
    ENV['RM_MONTHLY_CATCHUP_TAB'] = 'Yes'
    ENV['MR_REVIEW_TAB'] = 'Yes'
    ENV['OUTPUTS_ACTUALS_TAB'] = 'Yes'
    project_id
  end

  after do
    ENV['OUTPUTS_FORECAST_TAB'] = nil
    ENV['CONFIRMATION_TAB'] = nil
    ENV['S151_TAB'] = nil
    ENV['RM_MONTHLY_CATCHUP_TAB'] = nil
    ENV['MR_REVIEW_TAB'] = nil
    ENV['OUTPUTS_ACTUALS_TAB'] = nil
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
    File.open("#{__dir__}/../../fixtures/hif_saved_base_return_ui.json") do |f|
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


  def create_project
    dependency_factory.get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: hif_baseline,
      bid_id: 'HIF/MV/757'
    )[:id]
  end

  context 'Creating a return' do
    it 'Allows you to create and view a return' do
      stub_request(
        :get, "http://meow.cat/project/HIF%252FMV%252F757"
      ).to_return(
        status: 200,
        body: {
          "projectManager": "Max Stevens",
          "sponsor": "Timothy Turner"
        }.to_json
      ).with(
        headers: {'Authorization' => 'Bearer api.key.1' }
      )
      stub_request(
        :get, "http://meow.cat/project/HIF%252FMV%252F757/actuals"
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
        headers: {'Authorization' => 'Bearer api.key.1' }
      )

      base_return = get_use_case(:ui_get_base_return).execute(project_id: project_id)[:base_return]

      return_data = base_return[:data].dup

      return_id = dependency_factory.get_use_case(:ui_create_return).execute(project_id: project_id, data: return_data)[:id]
      return_data[:infrastructures][0][:planning][:outlinePlanning][:planningSubmitted][:status] = 'Delayed'
      return_data[:infrastructures][0][:planning][:outlinePlanning][:planningSubmitted][:reason] = 'Distracted by kittens'
      return_data[:s151] = {
        claimSummary: {
          hifTotalFundingRequest: '10000',
          hifSpendToDate: nil,
          AmountOfThisClaim: nil
        }
      }
      return_data[:s151Confirmation][:hifFunding][:hifTotalFundingRequest] = '10000'
      dependency_factory.get_use_case(:ui_update_return).execute(return_id: return_id, return_data: return_data)

      created_return = dependency_factory.get_use_case(:ui_get_return).execute(id: return_id, pcs_key: 'api.key.1')[:updates].last

      expect(created_return).to eq(expected_updated_return)
    end

    it 'Allows you to create a return with all the data in' do
      stub_request(
        :get, "http://meow.cat/project/HIF%252FMV%252F757"
      ).to_return(
        status: 200,
        body: {
          "projectManager": "Max Stevens",
          "sponsor": "Timothy Turner"
        }.to_json
      ).with(
        headers: {'Authorization' => 'Bearer api.key.1' }
      )
      stub_request(
        :get, "http://meow.cat/project/HIF%252FMV%252F757/actuals"
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
        headers: {'Authorization' => 'Bearer api.key.1' }
      )

      return_id = dependency_factory.get_use_case(:ui_create_return).execute(project_id: project_id, data: full_return_data)[:id]
      created_return = dependency_factory.get_use_case(:ui_get_return).execute(id: return_id, pcs_key: 'api.key.1')[:updates].last

      expect(created_return).to eq(full_return_data_after_calcs)
    end

    it 'Allows you to view multiple created returns' do
      base_return = get_use_case(:ui_get_base_return).execute(project_id: project_id)[:base_return]
      return_data = base_return[:data].dup

      dependency_factory.get_use_case(:ui_create_return).execute(project_id: project_id, data: return_data)[:id]
      dependency_factory.get_use_case(:ui_create_return).execute(project_id: project_id, data: return_data)[:id]

      created_returns = dependency_factory.get_use_case(:ui_get_returns).execute(project_id: project_id)[:returns]

      created_return_one = created_returns[0][:updates][0]
      created_return_two = created_returns[1][:updates][0]

      expect(created_return_one).to eq(hif_get_return)
      expect(created_return_two).to eq(hif_get_return)
    end
  end
end
