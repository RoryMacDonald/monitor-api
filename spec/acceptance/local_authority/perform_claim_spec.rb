# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Performing Claims on HIF Project' do
  include_context 'dependency factory'

  let(:expected_base_claim) do
    {
      "claimSummary": {},
      "supportingEvidence": {}
    }
  end

  let(:initial_claim) do
    {
      data: {
        claimSummary: {
          certifiedClaimForm: "some form",
          hifTotalFundingRequest: "Funding",
          hifSpendToDate: "0.0",
          AmountOfThisClaim: "lots",
          runningClaimTotal: "23"
        },
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: "500",
            actual: "400",
            varianceReason: "Areason",
            variance: {
              varianceAgainstForcastAmount: "456728",
              varianceAgainstForcastPercentage: "123456"
            }
          },
          evidenceOfSpendPastQuarter: "Much",
          breakdownOfNextQuarterSpend: {
            forecast: "4567",
            descriptionOfSpend: "Spending Money",
            evidenceOfSpendNextQuarter: "NOt got any"
          }
        }
      }
    }
  end

  let(:updated_claim) do
    {
      data: {
        claimSummary: {
          certifiedClaimForm: "changed",
          hifTotalFundingRequest: "Funding",
          hifSpendToDate: "0.0",
          AmountOfThisClaim: "lots",
          runningClaimTotal: "23"
        },
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: "100",
            actual: "100",
            varianceReason: "Areason",
            variance: {
              varianceAgainstForcastAmount: "456728",
              varianceAgainstForcastPercentage: "123456"
            }
          },
          evidenceOfSpendPastQuarter: "Much",
          breakdownOfNextQuarterSpend: {
            forecast: "4567",
            descriptionOfSpend: "Spending Money",
            evidenceOfSpendNextQuarter: "NOt got any"
          }
        }
      }
    }
  end

  let(:project_id) { database[:projects].insert(type: 'ac') }
  it 'Performs a claim' do
    id = get_use_case(:create_claim).execute(
      project_id: project_id,
      claim_data: initial_claim[:data]
    )[:claim_id]

    claim = get_use_case(:get_claim).execute(claim_id: id)

    expect(claim[:status]).to eq('Draft')
    expect(claim[:type]).to eq('ac')
    expect(claim[:project_id]).to eq(project_id)
    expect(claim[:data]).to eq(initial_claim[:data])

    get_use_case(:update_claim).execute(claim_id: id, claim_data: updated_claim)
    claim = get_use_case(:get_claim).execute(claim_id: id)
    expect(claim[:data]).to eq(updated_claim)

    get_use_case(:submit_claim).execute(claim_id: id)
    claim = get_use_case(:get_claim).execute(claim_id: id)
    expect(claim[:status]).to eq('Submitted')
  end
end
