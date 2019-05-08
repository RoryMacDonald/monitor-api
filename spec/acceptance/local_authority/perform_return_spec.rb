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

  let(:expected_ac_base_return) do
    File.open("#{__dir__}/../../fixtures/ac_base_return.json") do |f|
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
    {
      s151: {
        supportingEvidence: {
          lastQuarterMonthSpend: {
            forecast: '1'
          }
        }
      },
      fundingPackages: {
        fundingStack: [
          {
            currentFundingStackDescription: 'describe',
            fundedThroughHIF: 'Yes',
            totalCost: {
              currentAmount: '34'
            },
            hifSpend: {
              currentAmount: '23'
            },
            public: {
              currentAmount: '23',
              balancesSecured: {
                securedAgainstBaseline: '123'
              },
              amountSecured: '12'
            },
            private: {
              currentAmount: '12',
              balancesSecured: {
                securedAgainstBaseline: '124'
              },
              amountSecured: '13'
            }
          }
        ]
      },
      summary: {
        project_name: 'Dogs Protection League',
        description: 'A new headquarters for all the Dogs',
        lead_authority: 'Made Tech'
      },
      infrastructures: [
        {
          type: 'Dog Bathroom',
          description: 'Bathroom for Dogs',
          completion_date: '2018-12-25',
          planning: {
            submission_estimated: '2018-06-01',
            submission_actual: '2018-07-01',
            submission_delay_reason: 'Planning office was closed for summer',
            planningNotGranted: {
              fieldOne: {
                varianceCalculations: {
                  varianceAgainstLastReturn: {
                    varianceLastReturnFullPlanningPermissionSubmitted: nil
                  }
                }
              }
            },
            outlinePlanning: {
              planningSubmitted: {
                status: 'Completed',
                completedDate: '111',
                percentComplete: '12',
                onCompletedReference: 'REFPLAN'
              },
              planningGranted: {
                status: 'On Schedule',
                percentComplete: '34',
                completedDate: '222'
              }
            },
            fullPlanning: {
              submitted: {
                status: 'On Shedule',
                completedDate: '211',
                percentComplete: '45',
                onCompletedReference: 'REF2PLAN'
              },
              granted: {
                status: 'Delayed',
                percentComplete: '56',
                completedDate: '333'
              }
            }
          },
          landOwnership: {
            laDoesNotControlSite: {
              allLandAssemblyAchieved: {
                current: 'Tomorrow',
                status: 'complete',
                completedDate: 'today',
                percentComplete: '89'
              }
            }
          },
          procurement: {
            procurementStatusAgainstLastReturn: {
              statusAgainstLastReturn: 'Complete'
            },
            procurementCompletedDate: '23',
            procurementCompletedNameOfContractor: 'Mr'
          },
          milestones: {
            keyMilestones: [
              {
                currentReturn: '12/12/2012',
                statusAgainstLastReturn: 'Complete',
                milestoneCompletedDate: '1'
              }
            ],
            expectedInfrastructureStartOnSite: {
              status: 'Done',
              completedDate: '2'
            },
            expectedCompletionDateOfInfra: {
              status: 'not done',
              completedDate: '3'
            }
          },
          risks: {
            baselineRisks: [
              {
                riskMetDate: 'Yes',
                riskCompletionDate: '01/01/2018'
              }
            ]
          }
        }
      ],
      outputsForecast: {
        inYearHousingStarts: {
          currentAmounts: {
            quarter1: '12',
            quarter2: '23',
            quarter3: '34',
            quarter4: '45'
          }
        },
        inYearHousingCompletions: {
          currentAmounts: {
            quarter1: '12',
            quarter2: '23',
            quarter3: '34',
            quarter4: '45'
          }
        }
      },
      funding: [
        {
          fundingPackages: [
            fundingPackage: {
              overview: {
                hifSpendSinceLastReturn: {
                  hifSpendCurrentReturn: '25565'
                }
              }
            }
          ]
        }
      ],
      financial: {
        total_amount_estimated: '£ 1000000.00',
        total_amount_actual: nil,
        total_amount_changed_reason: nil
      },
      hifRecovery: {
        recovery: {
          expectedAmountToRecover: {
            changeToBaseline: {
              confirmation: 'Yes',
              lastReturn: '12',
              currentCopy: '14'
            }
          }
        }
      }
    }
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
