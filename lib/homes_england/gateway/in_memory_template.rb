# frozen_string_literal: true

class HomesEngland::Gateway::InMemoryTemplate
  def get_template(type:)
    return nil unless type == 'hif'
    hif_template = HomesEngland::Domain::Template.new
    hif_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'HIF Project',
      type: 'object',
      properties: {
        projectSummary: {
          type: 'object',
          title: 'Project Summary',
          properties: {
            BIDReference: {
              type: 'string',
              title: 'BID Reference'
            },
            projectName: {
              type: 'string',
              title: 'Project Name'
            },
            leadAuthority: {
              type: 'string',
              title: 'Lead Authority'
            },
            projectDescription: {
              type: 'string',
              title: 'Project Description'
            },
            noOfHousingSites: {
              type: 'integer',
              title: 'Number of housing sites'
            },
            totalArea: {
              type: 'integer',
              title: 'Total Area (hectares)'
            },
            hifFundingAmount: {
              type: 'integer',
              title: 'HIF Funding Amount (£)'
            },
            descriptionOfInfrastructure: {
              type: 'string',
              title: 'Description of HIF Infrastructure to be delivered'
            },
            descriptionOfWiderProjectDeliverables: {
              type: 'string',
              title: 'Description of wider project deliverables'
            }
          }
        },
        infrastructures: {
          type: 'array',
          title: 'Infrastructures',
          items: [
            {
              type: 'object',
              properties: {
                type: {
                  type: 'string',
                  title: 'Type'
                },
                description: {
                  type: 'string',
                  title: 'Description'
                },
                outlinePlanningStatus: {
                  type: 'object',
                  title: 'Outline Planning Status',
                  properties: {
                    granted: {
                      type: 'boolean',
                      title: 'Granted?'
                    },
                    grantedReference: {
                      type: 'string',
                      title: 'If Yes: Reference '
                    },
                    targetSubmission: {
                      type: 'string',
                      format: 'date',
                      title: 'If No: Target date of submission'
                    },
                    targetGranted: {
                      type: 'string',
                      format: 'date',
                      title: 'If No: Target date of planning granted'
                    },
                    summaryOfCriticalPathInfrastructures: {
                      type: 'string',
                      title: 'If No: Summary of Critical Path'
                    }
                  }
                },
                fullPlanningStatus: {
                  type: 'object',
                  title: 'Full Planning Status',
                  properties: {
                    granted: {
                      type: 'boolean',
                      title: 'Granted?'
                    },
                    grantedReference: {
                      type: 'string',
                      title: 'If Yes: Reference '
                    },
                    targetSubmission: {
                      type: 'string',
                      format: 'date',
                      title: 'If No: Target date of submission'
                    },
                    targetGranted: {
                      type: 'string',
                      format: 'date',
                      title: 'If No: Target date of planning granted'
                    },
                    summaryOfCriticalPath: {
                      type: 'string',
                      title: 'If No: Summary of Critical Path'
                    }
                  }
                },
                s106: {
                  type: 'object',
                  title: 'Section 106',
                  properties: {
                    requirement: { type: 'boolean',
                                   title: 'A requirement?' },
                    summaryOfRequirement: {
                      type: 'string',
                      title: 'If Yes: Summary of requirement'
                    }
                  }
                },
                statutoryConsents: {
                  type: 'object',
                  title: 'Section 106',
                  properties: {
                    anyConsents: { type: 'boolean',
                                   title: 'Any Statutory Consents?' },
                    detailsOfConsent: {
                      type: 'string',
                      title: 'If Yes: Details of consent'
                    },
                    targetDateToBeMet: {
                      type: 'string',
                      format: 'date',
                      title: 'If Yes: Target date to be met'
                    }
                  }
                },
                landOwnership: {
                  type: 'object',
                  title: 'Land Ownership',
                  properties: {
                    underControlOfLA: {
                      type: 'boolean',
                      title: 'Is land under control of the Local Authority'
                    },
                    ownershipOfLandOtherThanLA: {
                      type: 'string',
                      title: 'If No: who owns it?'
                    },
                    landAcquisitionRequired: {
                      type: 'boolean',
                      title: 'Is land acquisition required?'
                    },

                    howManySitesToAquire: {
                      type: 'integer',
                      title: 'If Yes: How many sites to aquire?'
                    },

                    toBeAquiredBy: {
                      type: 'string',
                      title: 'If Yes: Is this to be acquired by LA or developer?'
                    },

                    targetDateToAquire: {
                      type: 'string',
                      format: 'date',
                      title: 'If Yes: Target date to aquire sites'
                    },

                    summaryOfCriticalPath: {
                      type: 'string',
                      title: 'If Yes: Summary of Critical Path'
                    }
                  }
                },
                procurement: {
                  type: 'object',
                  title: 'Procurement',
                  properties: {
                    contractorProcured: {
                      type: 'boolean',
                      title: 'Is the infrastructure contractor procured?'
                    },

                    nameOfContractor: {
                      type: 'string',
                      title: 'If Yes: Name of Contractor?'
                    },

                    targetDateToAquire: {
                      type: 'string',
                      format: 'date',
                      title: 'If No: Target date of procuring'
                    },

                    summaryOfCriticalPath: {
                      type: 'string',
                      title: 'If No: Summary of Critical Path'
                    }
                  }
                },
                milestones: {
                  type: 'array',
                  title: 'Key Infrastructure Milestones',
                  items: [
                    type: 'object',
                    properties: {
                      descriptionOfMilestone: {
                        type: 'string',
                        title: 'Description of Milestone'
                      },
                      target: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of achieving'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        format: 'date',
                        title: 'Summary of Critical Path'
                      }

                    }

                  ]
                },
                expectedInfrastructureStart: {
                  type: 'object',
                  title: 'Expected infrastructure start on site',
                  properties: {
                    targetDateOfAchievingStart: {
                      type: 'string',
                      format: 'date',
                      title: 'Target date of achieving start'
                    }
                  }
                },
                expectedInfrastructureCompletion: {
                  type: 'object',
                  title: 'Expected infrastructure completion',
                  properties: {
                    targetDateOfAchievingCompletion: {
                      type: 'string',
                      format: 'date',
                      title: 'Target date of achieving completion'
                    }
                  }
                },
                risksToAchievingTimescales: {
                  type: 'object',
                  title: 'Risks to achieving timescales',
                  properties: {
                    descriptionOfRisk: {
                      type: 'string',
                      title: 'Description Of Risk'
                    },
                    impactOfRisk: {
                      type: 'string',
                      title: 'Impact'
                    },
                    likelihoodOfRisk: {
                      type: 'string',
                      title: 'Likelihood'
                    },
                    mitigationOfRisk: {
                      type: 'string',
                      title: 'Mitigation in place'
                    }
                  }
                }
              }
            }
          ]
        },
        financial: {
          type: 'array',
          title: 'Financials',
          items: [
            {
              type: 'object',
              properties: {

                instalments: {
                  type: 'array',
                  title: 'Instalments',
                  items: [
                    type: 'object',
                    properties: {
                      dateOfInstalment: {
                        type: 'string',
                        format: 'date',
                        title: 'Date of Instalment'
                      },
                      instalmentAmount: {
                        type: 'string',
                        title: 'HIF Funding Profile - Baseline'
                      }
                    }
                  ]
                },
                costs: {
                  type: 'array',
                  title: 'Cost of Infrastructures',
                  items: [
                    type: 'object',
                    properties: {
                      costOfInfrastructure: {
                        type: 'string',
                        title: 'Cost of Infrastructure'
                      },
                      fundingStack: {
                        type: 'object',
                        title: 'Totally funded through HIF',
                        properties: {
                          totallyFundedThroughHIF: {
                            type: 'boolean',
                            title: 'Totally funded through HIF?'
                          },
                          descriptionOfFundingStack: {
                            type: 'string',
                            title: 'If No: Description of Funding Stack'
                          },
                          totalPublic: {
                            type: 'string',
                            title: 'If No, Total Public (exc. HIF)'
                          },
                          totalPrivate: {
                            type: 'string',
                            title: 'If No, Total Private'
                          }
                        }
                      }
                    }
                  ]
                },
                baselineCashflow: {
                  type: 'object',
                  title: 'Baseline Cashflow',
                  properties: {
                    summaryOfRequirement: {
                      type: 'string',
                      format: 'data-url',
                      title: 'Baseline Cashflow'
                    }
                  }
                },

                recovery: {
                  type: 'object',
                  title: 'Recovery',
                  properties: {
                    aimToRecover: {
                      type: 'boolean',
                      title: 'Aim to Recover?'
                    },
                    expectedAmountToRemove: {
                      type: 'integer',
                      title: 'Expected Amount'
                    },
                    methodOfRecovery: {
                      type: 'boolean',
                      title: 'Method of Recovery?'
                    }
                  }
                }
              }
            }
          ]
        }
      }
    }

    hif_template.layout = {
      summary: {
        project_name: nil,
        description: nil,
        lead_authority: nil
      },
      infrastructure: {
        type: nil,
        description: nil,
        completion_date: nil,
        planning: {
          submission_estimated: nil
        }
      },
      financial: {
        total_amount_estimated: nil
      }
    }
    hif_template
  end
end
