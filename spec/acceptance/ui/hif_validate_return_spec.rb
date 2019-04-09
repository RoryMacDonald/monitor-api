# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF return' do
  include_context 'dependency factory'

  context 'Invalid HIF return' do
    # percent complete set to > 100
    let(:project_base_return_invalid) do
      File.open("#{__dir__}/../../fixtures/base_return.json") do |f|
        JSON.parse(
          f.read,
          symbolize_names: true
        )
      end
    end

    it 'should return invalid if fails validation' do
      allow(ENV).to receive(:[]).and_return(true)

      valid_return = get_use_case(:ui_validate_return).execute(type: 'hif', return_data: project_base_return_invalid)
      expect(valid_return[:valid]).to eq(false)
      expect(valid_return[:invalid_paths]).to eq([
        [:infrastructures, 0, :planning, :outlinePlanning, :planningSubmitted, :percentComplete],
        [:infrastructures, 0, :planning, :outlinePlanning, :planningGranted, :percentComplete],
        [:infrastructures, 0, :planning, :fullPlanning, :submitted, :percentComplete],
        [:infrastructures, 0, :planning, :fullPlanning, :granted, :percentComplete],
        [:infrastructures, 0, :milestones, :keyMilestones, 0, :milestonePercentCompleted],
        [:infrastructures, 0, :risks, :baselineRisks, 0, :riskMet],
        [:fundingProfiles, :changeRequired],
        [:fundingPackages, 0, :fundingStack, :totalCost, :anyChange],
        [:s151Confirmation, :hifFunding, :cashflowConfirmation]
      ])
      expect(valid_return[:pretty_invalid_paths]).to eq([
        ["HIF Project", "Infrastructures", "Infrastructure 1", "Planning", "Outline Planning", "Planning Permission Submitted", "Percent Complete"],
        ["HIF Project", "Infrastructures", "Infrastructure 1", "Planning", "Outline Planning", "Planning Permission Granted", "Percent Complete"],
        ["HIF Project", "Infrastructures", "Infrastructure 1", "Planning", "Full Planning", "Planning permission Submitted", "Percent Complete"],
        ["HIF Project", "Infrastructures", "Infrastructure 1", "Planning", "Full Planning", "Planning Permission Granted", "Percent Complete"],
        ["HIF Project", "Infrastructures", "Infrastructure 1", "Milestones", "Key Project Milestones", "Key Project Milestone 1", "Percent complete"],
        ["HIF Project", "Infrastructures", "Infrastructure 1", "Risks", "Baseline Risks", "Risk 1", "Risk Met?"],
        ["HIF Project", "HIF Grant Expenditure", "Change Required?"],
        ["HIF Project", "Funding Packages", "Funding for Infrastructure 1", "Funding stack", "", "Any change to baseline/ last return?"],
        ["HIF Project", "s151 Confirmation", "HIF Funding and Profiles", "Please confirm you are content with the submitted project cashflows"]
      ])
    end
  end

  context 'required field validation' do
    let(:template) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          fundingPackages: {
            type: 'array',
            title: 'Funding Packages',
            items: {
              type: 'object',
              title: 'Funding for Infrastructure',
              properties: {
                fundingStack: {
                  type: 'object',
                  title: 'Funding stack',
                  properties: {
                    hifSpend: {
                      title: 'HIF Spend',
                      type: 'object',
                      horizontal: true,
                      properties: {
                        baseline: {
                          type: 'string',
                          title: 'HIF Baseline Amount',
                          sourceKey: %i[baseline_data costs infrastructure HIFAmount],
                          readonly: true,
                          currency: true
                        },
                        current: {
                          type: 'string',
                          title: 'Current Return',
                          currency: true
                        },
                        lastReturn: {
                          type: 'string',
                          title: 'Last Return',
                          readonly: true,
                          currency: true,
                          sourceKey: %i[return_data fundingPackages hifSpend current]
                        }
                      }
                    },
                    totalCost: {
                      title: 'Total Cost',
                      type: 'object',
                      horizontal: true,
                      properties: {
                        baseline: {
                          type: 'string',
                          title: 'Baseline Amount',
                          sourceKey: %i[baseline_data costs infrastructure totalCostOfInfrastructure],
                          readonly: true,
                          currency: true
                        },
                        current: {
                          type: 'string',
                          title: 'Current return',
                          currency: true
                        },
                        varianceReason: {
                          type: 'string',
                          title: 'Reason for variance'
                        },
                        percentComplete: {
                          type: 'string',
                          title: 'Percent complete',
                          percentage: true
                        }
                      }
                    },
                    fundedThroughHIF: {
                      type: 'string',
                      title: 'Totally funded through HIF?',
                      radio: true,
                      enum: %w[Yes No],
                      readonly: true,
                      sourceKey: %i[baseline_data costs infrastructure totallyFundedThroughHIF]
                    }
                  },
                  dependencies: {
                    fundedThroughHIF: {
                      oneOf: [
                        {
                          properties: {
                            fundedThroughHIF: {
                              enum: ['Yes']
                            }
                          }
                        },
                        {
                          properties: {
                            fundedThroughHIF: {
                              enum: ['No']
                            },
                            descriptionOfFundingStack: {
                              type: 'string',
                              title: 'Description of funding stack',
                              readonly: true,
                              sourceKey: %i[baseline_data costs infrastructure descriptionOfFundingStack]
                            },
                            riskToFundingPackage: {
                              type: 'object',
                              horizontal: true,
                              title: 'Risk to funding package',
                              properties: {
                                risk: {
                                  title: 'Is there a risk?',
                                  type: 'string',
                                  radio: true,
                                  enum: %w[Yes No]
                                },
                                description: {
                                  title: 'Description of risk',
                                  type: 'string'
                                }
                              }
                            },
                            public: {
                              title: 'Total Public',
                              type: 'object',
                              horizontal: true,
                              properties: {
                                baseline: {
                                  title: 'Total baseline amount',
                                  type: 'string',
                                  readonly: true,
                                  currency: true,
                                  sourceKey: %i[baseline_data costs infrastructure totalPublic]
                                },
                                current: {
                                  title: 'Total - Current return',
                                  type: 'string',
                                  currency: true
                                },
                                reason: {
                                  title: 'Reason for variance',
                                  type: 'string'
                                },
                                amountSecured: {
                                  title: 'Amount secured to date',
                                  type: 'string',
                                  currency: true
                                }
                              }
                            },
                            private: {
                              title: 'Total Private',
                              type: 'object',
                              horizontal: true,
                              properties: {
                                baseline: {
                                  title: 'Total baseline amount',
                                  type: 'string',
                                  readonly: true,
                                  currency: true,
                                  sourceKey: %i[baseline_data costs infrastructure totalPrivate]
                                },
                                current: {
                                  title: 'Total - Current return',
                                  type: 'string',
                                  currency: true
                                },
                                reason: {
                                  title: 'Reason for variance',
                                  type: 'string'
                                },
                                amountSecured: {
                                  title: 'Amount secured to date',
                                  type: 'string',
                                  currency: true
                                }
                              }
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              }
            }
          }
        }
      end
    end
    let(:data) do
      {

      }
    end
  end
end
