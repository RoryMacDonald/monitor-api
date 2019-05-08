# frozen_string_literal: true

describe 'Interacting with the HIF claim from the UI' do
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

  let(:claim_data) do
    File.open("#{__dir__}/../../fixtures/hif_claim_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:expected_claim_data) { claim_data }

  let(:updated_claim_data) do
    File.open("#{__dir__}/../../fixtures/hif_updated_claim_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:expected_updated_claim_data) do
    {
      "claimSummary": {
        "hifTotalFundingRequest": '283185307179586',
        "hifSpendToDate": '0.0',
        "certifiedClaimForm": 'some form',
        "AmountOfThisClaim": 'Quantative',
        "runningClaimTotal": '2831853'
      },
      "supportingEvidence": {
        "lastQuarterMonthSpend": {
          "forecast": '500',
          "actual": '400',
          "varianceReason": 'Areason',
          "variance": {
            "varianceAgainstForcastAmount": '28318530717958',
            "varianceAgainstForcastPercentage": '123456'
          }
        },
        "evidenceOfSpendPastQuarter": 'Much',
        "breakdownOfNextQuarterSpend": {
          "forecast": '2838',
          "descriptionOfSpend": 'Spending Money',
          "evidenceOfSpendNextQuarter": 'Not got any'
        }
      }
    }
  end

  let(:hif_baseline) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:created_claim) do
    get_use_case(:ui_create_claim).execute(project_id: project_id, claim_data: claim_data)
  end

  let(:found_claim) do
    get_use_case(:ui_get_claim).execute(claim_id: created_claim[:claim_id])
  end

  before do
    ENV['PCS'] = 'yes'
    ENV['PCS_DOMAIN'] = pcs_domain
    ENV['PCS_SECRET'] = pcs_secret

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

  after do
    ENV['PCS'] = nil
    ENV['PCS_DOMAIN'] = nil
    ENV['PCS_SECRET'] = nil
  end

  def create_project
    get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: hif_baseline,
      bid_id: 'HIF/MV/757'
    )[:id]
  end

  def given_a_hif_project
    project_id
  end

  def given_a_hif_project_with_a_claim
    project_id
    created_claim
  end

  def when_the_user_creates_a_claim
    created_claim
  end

  def when_the_user_updates_the_claim
    get_use_case(:ui_update_claim).execute(
      claim_id: created_claim[:claim_id],
      claim_data: updated_claim_data
    )
  end

  def then_the_claim_can_be_viewed
    expect(found_claim[:id]).to eq(created_claim[:claim_id])
    expect(found_claim[:project_id]).to eq(project_id)
    expect(found_claim[:data]).to eq(expected_claim_data)
  end

  def then_the_updated_claim_can_be_viewed
    expect(found_claim[:data]).to eq(expected_updated_claim_data)
  end

  it 'Allows the user to create and view a claim' do
    given_a_hif_project
    when_the_user_creates_a_claim
    then_the_claim_can_be_viewed
  end

  it 'Allows the user to update a claim' do
    given_a_hif_project_with_a_claim
    when_the_user_updates_the_claim
    then_the_updated_claim_can_be_viewed
  end
end
