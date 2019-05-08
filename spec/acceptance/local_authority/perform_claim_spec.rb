# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Performing Claims on HIF Project' do
  include_context 'dependency factory'

  let(:expected_base_claim) do
    {
      claimSummary: {
        hifTotalFundingRequest: "123456",
        hifSpendToDate: nil
      },
      supportingEvidence: {
        lastQuarterMonthSpend: {
          forecast: nil
        }
      }
    }
  end

  let(:initial_claim_data) do
    File.open("#{__dir__}/../../fixtures/hif_claim_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:updated_claim) do
    File.open("#{__dir__}/../../fixtures/hif_updated_claim_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:baseline_data) do
    {
      summary: {
        hifFundingAmount: "123456"
      }
    }
  end

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      name: '',
      type: 'hif',
      baseline: baseline_data,
      bid_id: 'HIF/MV/45'
    )[:id]
  end


  let(:base_claim) { get_use_case(:get_base_claim).execute(project_id: project_id) }
  let(:id) do
    get_use_case(:create_claim).execute(
      project_id: project_id,
      claim_data: initial_claim_data
    )[:claim_id]
  end

  def when_getting_a_base_claim
    base_claim
  end

  def given_a_project
    project_id
  end

  context do
    def then_it_provides_a_base_claim
      expect(base_claim[:base_claim][:data]).to eq(expected_base_claim)
    end

    it 'Gets base claim' do
      given_a_project
      when_getting_a_base_claim
      then_it_provides_a_base_claim
    end
  end

  context do
    let(:claim) { get_use_case(:get_claim).execute(claim_id: id) }

    def when_a_new_claim_is_created
      id
    end

    def and_when_the_claim_is_retrieved
      claim
    end

    def then_it_has_the_correct_data
      expect(claim[:status]).to eq('Draft')
      expect(claim[:type]).to eq('hif')
      expect(claim[:project_id]).to eq(project_id)
      expect(claim[:data]).to eq(initial_claim_data)
    end

    it 'Creates and retrieves a claim' do
      given_a_project
      when_a_new_claim_is_created
      and_when_the_claim_is_retrieved
      then_it_has_the_correct_data
    end

    def given_a_new_claim
      id
    end

    def when_the_claim_is_updated
      get_use_case(:update_claim).execute(claim_id: id, claim_data: updated_claim)
    end

    def then_the_claim_had_the_updated_data
      expect(claim[:data]).to eq(updated_claim)
    end

    it 'Updates a claim' do
      given_a_new_claim
      when_the_claim_is_updated
      and_when_the_claim_is_retrieved
      then_the_claim_had_the_updated_data
    end

    def when_the_claim_is_submited
      get_use_case(:submit_claim).execute(claim_id: id)
    end

    def then_the_claim_status_is_submitted
      expect(claim[:status]).to eq('Submitted')
    end

    it 'Submits a claim' do
      given_a_new_claim
      when_the_claim_is_submited
      and_when_the_claim_is_retrieved
      then_the_claim_status_is_submitted
    end
  end

  context do
    def given_a_project_with_a_submitted_claim
      project_id
      id
      get_use_case(:submit_claim).execute(claim_id: id)
    end

    let(:expected_base_claim) do
      {
        claimSummary: {
          hifTotalFundingRequest: "123456",
          hifSpendToDate: "23"
        },
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: "4567"
          }
        }
      }
    end

    def then_the_base_claim_includes_data_from_previous_claim
      expect(base_claim[:base_claim][:data]).to eq(expected_base_claim)
    end

    it 'Submitting a claim changes future base claims' do
      given_a_project_with_a_submitted_claim
      when_getting_a_base_claim
      then_the_base_claim_includes_data_from_previous_claim
    end
  end
end
