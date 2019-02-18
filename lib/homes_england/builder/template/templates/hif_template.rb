# frozen_string_literal: true

class HomesEngland::Builder::Template::Templates::HIFTemplate
  def self.create
    hif_template = Common::Domain::Template.new
    hif_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'HIF Project',
      type: 'object',
      properties: {
        summary: hif_summary,
        infrastructures: hif_infrastructures,
        fundingProfiles: {
          type: 'array',
          title: 'Funding profiles',
          items: {
            type: 'object',
            title: 'Funding Profile',
            properties: {
              period: { type: 'string', title: 'Period' },
              instalment1: { type: 'string', title: '1st Instalment', currency: true },
              instalment2: { type: 'string', title: '2nd Instalment', currency: true },
              instalment3: { type: 'string', title: '3rd Instalment', currency: true },
              instalment4: { type: 'string', title: '4th Instalment', currency: true },
              total: { type: 'string', title: 'Total', currency: true }
            },
            required: %w[period instalment1 instalment2 instalment3 instalment4 total]
          }
        },
        costs: {
          type: 'array',
          title: 'Costs',
          items: {
            type: 'object',
            title: 'Cost',
            properties: {
              infrastructure: {
                type: 'object',
                title: 'Infrastructure',
                properties: {
                  HIFAmount: {
                    type: 'string',
                    title: 'Total HIF Amount',
                    currency: true
                  },
                  totalCostOfInfrastructure: {
                    type: 'string',
                    title: 'Total Cost of Infrastructure',
                    currency: true
                  },
                  totallyFundedThroughHIF: {
                    type: 'string',
                    title: 'Totally funded through HIF?',
                    radio: true,
                    enum: %w[Yes No]
                  }
                },
                dependencies: {
                  totallyFundedThroughHIF: {
                    oneOf: [
                      {
                        properties: {
                          totallyFundedThroughHIF: {
                            enum: ['Yes']
                          }
                        }
                      },
                      {
                        properties: {
                          totallyFundedThroughHIF: {
                            enum: ['No']
                          },
                          descriptionOfFundingStack: {
                            type: 'string',
                            title: 'If No: Description of Funding Stack'
                          },
                          totalPublic: {
                            type: 'string',
                            title: 'If No, Total Public (exc. HIF)',
                            currency: true
                          },
                          totalPrivate: {
                            type: 'string',
                            title: 'If No, Total Private',
                            currency: true
                          }
                        },
                        required: %w[
                          descriptionOfFundingStack totalPublic totalPrivate
                        ]
                      }
                    ]
                  }
                }
              }
            }
          }
        },
        recovery: {
          type: 'object',
          title: 'Recovery',
          properties: {
            aimToRecover: {
              type: 'string',
              title: 'Aim to recover funds?',
              radio: true,
              enum: %w[Yes No]
            }
          },
          dependencies: {
            aimToRecover: {
              oneOf: [
                {
                  properties: {
                    aimToRecover: {
                      enum: ['Yes']
                    },
                    expectedAmount: {
                      type: 'string',
                      title: 'Expected Amount',
                      currency: true
                    },
                    methodOfRecovery: {
                      type: 'string',
                      title: 'Method of Recovery',
                      extendedText: true
                    }
                  }

                },
                {
                  properties: {
                    aimToRecover: {
                      enum: ['No']
                    }
                  }
                }
              ]
            }
          }
        },
        s151: hif_s151,
        outputsForecast: outputs_forecast,
        outputsActuals: outputs_actuals,
        rmBaseline: rm_baseline
      }
    }
    hif_template
  end

  def self.hif_infrastructures
    {
      type: 'array',
      title: 'Infrastructures',
      items: {
        title: 'Infrastructure',
        type: 'object',
        properties: {
          type: {
            type: 'string',
            laReadOnly: true,
            title: 'Type'
          },
          description: {
            type: 'string',
            laReadOnly: true,
            title: 'Description'
          },
          housingSitesBenefitting: {
            type: 'string',
            title: 'Housing Sites Benefitting'
          },
          outlinePlanningStatus: {
            type: 'object',
            title: 'Outline Planning Status',
            properties: {
              granted: {
                type: 'string',
                title: 'Granted?',
                radio: true,
                enum: ['Yes', 'No', 'N/A']
              }
            },
            required: %w[granted],
            dependencies: {
              granted: {
                oneOf: [
                  {
                    properties: {
                      granted: {
                        enum: ['Yes']
                      },
                      reference: {
                        type: 'string',
                        title: 'Reference'
                      }
                    },
                    required: %w[reference]
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['No']
                      },
                      targetSubmission: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of submission'
                      },
                      targetGranted: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of planning granted'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        title: 'Summary of Critical Path'
                      }
                    },
                    required: %w[
                      targetSubmission targetGranted summaryOfCriticalPath
                    ]
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['N/A']
                      }
                    }
                  }
                ]
              }
            }
          },
          fullPlanningStatus: {
            type: 'object',
            title: 'Full Planning Status',
            properties: {
              granted: {
                type: 'string',
                title: 'Granted?',
                radio: true,
                enum: ['Yes', 'No', 'N/A']
              }
            },
            required: %w[granted],
            dependencies: {
              granted: {
                oneOf: [
                  {
                    properties: {
                      granted: {
                        enum: ['Yes']
                      },
                      grantedReference: {
                        type: 'string',
                        title: 'Reference'
                      }
                    },
                    required: %w[grantedReference]
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['No']
                      },
                      targetSubmission: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of submission'
                      },
                      targetGranted: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of planning granted'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        title: 'Summary of Critical Path'
                      }
                    },
                    required: %w[
                      targetSubmission targetGranted summaryOfCriticalPath
                    ]
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['N/A']
                      }
                    }
                  }
                ]
              }
            }
          },
          s106: {
            type: 'object',
            title: 'Section 106',
            properties: {
              requirement: {
                type: 'string',
                laReadOnly: true,
                title: 'Is this a requirement?',
                radio: true,
                enum: %w[Yes No]
              }
            },
            required: %w[requirement],
            dependencies: {
              requirement: {
                oneOf: [
                  {
                    properties: {
                      requirement: {
                        enum: ['Yes']
                      },
                      summaryOfRequirement: {
                        type: 'string',
                        title: 'If Yes: Summary of requirement'
                      }
                    },
                    required: %w[summaryOfRequirement]
                  },
                  {
                    properties: {
                      requirement: {
                        enum: ['No']
                      }
                    }
                  }
                ]
              }
            }
          },
          statutoryConsents: {
            type: 'object',
            title: 'Statutory Consents',
            properties: {
              anyConsents: {
                type: 'string',
                laReadOnly: true,
                title: 'Any Statutory Consents?',
                radio: true,
                enum: %w[Yes No]
              }
            },
            required: %w[anyConsents],
            dependencies: {
              anyConsents: {
                oneOf: [
                  {
                    properties: {
                      anyConsents: {
                        enum: ['Yes']
                      },
                      consents: {
                        title: 'Consents',
                        type: 'array',
                        items: {
                          title: 'Statutory Consent',
                          type: 'object',
                          properties: {
                            detailsOfConsent: {
                              type: 'string',
                              title: 'Details of consent'
                            },
                            targetDateToBeMet: {
                              type: 'string',
                              format: 'date',
                              title: 'Target date to be met'
                            }
                          },
                          required: %w[detailsOfConsent targetDateToBeMet]
                        }
                      }
                    }
                  },
                  {
                    properties: {
                      anyConsents: {
                        enum: ['No']
                      }
                    }
                  }
                ]
              }
            }
          },
          landOwnership: {
            type: 'object',
            title: 'Land Ownership',
            properties: {
              underControlOfLA: {
                type: 'string',
                title: 'Is land under control of the Local Authority',
                radio: true,
                enum: %w[Yes No]
              }
            },
            required: %w[underControlOfLA],
            dependencies: {
              underControlOfLA: {
                oneOf: [
                  {
                    properties: {
                      underControlOfLA: {
                        enum: ['No']
                      },
                      ownershipOfLandOtherThanLA: {
                        type: 'string',
                        title: 'Who owns it?'
                      },
                      isLandAcquisitionRequired: {
                        type: 'string',
                        title: 'Is land acquisition required?',
                        radio: true,
                        enum: %w[Yes No]
                      }
                    },
                    required: %w[ownershipOfLandOtherThanLA isLandAcquisitionRequired],
                    dependencies: {
                      isLandAcquisitionRequired: {
                        oneOf: [
                          {
                            properties: {
                              isLandAcquisitionRequired: {
                                enum: ['No']
                              }
                            }
                          },
                          {
                            properties: {
                              isLandAcquisitionRequired: {
                                enum: ['Yes']
                              },
                              sitesToAcquire: {
                                type: 'string',
                                title: 'How many sites?'
                              },
                              acquiredBy: {
                                type: 'string',
                                title: 'Is this to be acquired by LA or developer?'
                              },
                              dateToAcquire: {
                                type: 'string',
                                format: 'date',
                                title: 'Target date to aquire sites'
                              },
                              criticalPath: {
                                type: 'string',
                                title: 'Summary of Critical Path'
                              }
                            },
                            required: %w[
                              sitesToAcquire acquiredBy dateToAcquire criticalPath
                            ]
                          }
                        ]
                      }
                    }
                  },
                  {
                    properties: {
                      underControlOfLA: {
                        enum: ['Yes']
                      },
                      landAcquisitionRequired: {
                        type: 'string',
                        title: 'Is land acquisition required?',
                        radio: true,
                        enum: %w[Yes No]
                      }
                    },
                    required: %w[landAcquisitionRequired],
                    dependencies: {
                      landAcquisitionRequired: {
                        oneOf: [
                          {
                            properties: {
                              landAcquisitionRequired: {
                                enum: ['No']
                              }
                            }
                          },
                          {
                            properties: {
                              landAcquisitionRequired: {
                                enum: ['Yes']
                              },
                              howManySitesToAcquire: {
                                type: 'string',
                                title: 'How many sites?'
                              },
                              toBeAcquiredBy: {
                                type: 'string',
                                title: 'Is this to be acquired by LA or developer?'
                              },
                              targetDateToAcquire: {
                                type: 'string',
                                format: 'date',
                                title: 'Target date to aquire sites'
                              },
                              summaryOfCriticalPath: {
                                type: 'string',
                                title: 'Summary of Critical Path'
                              }
                            },
                            required: %w[
                              howManySitesToAcquire toBeAcquiredBy targetDateToAcquire summaryOfCriticalPath
                            ]
                          }
                        ]
                      }
                    }
                  }
                ]
              }
            }
          },
          procurement: {
            type: 'object',
            title: 'Procurement',
            properties: {
              contractorProcured: {
                type: 'string',
                title: 'Is the infrastructure contractor procured?',
                radio: true,
                enum: %w[Yes No]
              }
            },
            required: %w[contractorProcured],
            dependencies: {
              contractorProcured: {
                oneOf: [
                  {
                    properties: {
                      contractorProcured: {
                        enum: ['Yes']
                      },
                      nameOfContractor: {
                        type: 'string',
                        title: 'Name of Contractor'
                      }
                    },
                    required: %w[nameOfContractor]
                  },
                  {
                    properties: {
                      contractorProcured: {
                        enum: ['No']
                      },
                      targetDate: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of procuring'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        title: 'Summary of critical path'
                      }
                    },
                    required: %w[targetDate summaryOfCriticalPath]
                  }
                ]
              }
            }
          },
          milestones: {
            type: 'array',
            title: 'Key Infrastructure Milestones',
            items: {
              title: 'Milestone',
              type: 'object',
              properties: {
                descriptionOfMilestone: {
                  type: 'string',
                  laReadOnly: true,
                  title: 'Description of Milestone'
                },
                target: {
                  type: 'string',
                  format: 'date',
                  title: 'Target date of achieving'
                },
                summaryOfCriticalPath: {
                  type: 'string',
                  title: 'Summary of Critical Path'
                }
              },
              required: %w[descriptionOfMilestone target summaryOfCriticalPath]
            }
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
            },
            required: %w[targetDateOfAchievingStart]
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
            },
            required: %w[targetDateOfAchievingCompletion]
          },
          risksToAchievingTimescales: {
            type: 'array',
            title: 'Risks to achieving timescales',
            items: {
              title: 'Risk',
              type: 'object',
              properties: {
                descriptionOfRisk: {
                  type: 'string',
                  laReadOnly: true,
                  title: 'Description Of Risk'
                },
                impactOfRisk: {
                  type: 'string',
                  laReadOnly: true,
                  title: 'Impact'
                },
                likelihoodOfRisk: {
                  type: 'string',
                  laReadOnly: true,
                  title: 'Likelihood'
                },
                mitigationOfRisk: {
                  type: 'string',
                  title: 'Mitigation in place'
                }
              },
              required: %w[mitigationOfRisk]
            }
          }
        },
        required: %w[housingSitesBenefitting]
      }
    }
  end

  def self.hif_summary
    {
      type: 'object',
      title: 'Project Summary',
      properties: {
        BIDReference: {
          type: 'string',
          laReadOnly: true,
          title: 'BID Reference'
        },
        projectName: {
          type: 'string',
          laReadOnly: true,
          title: 'Project Name'
        },
        leadAuthority: {
          type: 'string',
          laReadOnly: true,
          title: 'Lead Authority'
        },
        jointBidAreas: {
          type: 'string',
          title: 'Joint Bid Areas'
        },
        projectDescription: {
          type: 'string',
          laReadOnly: true,
          title: 'Project Description'
        },
        greenOrBrownField: {
          type: 'string',
          title: 'Greenfield/Brownfield/Mixed',
          radio: true,
          enum: %w[Greenfield Brownfield Mixed]
        },
        noOfHousingSites: {
          type: 'string',
          laReadOnly: true,
          title: 'Number of housing sites'
        },
        polygonsForHousingSite: {
          type: 'string',
          title: 'Polygons for housing sites',
          format: 'uri'
        },
        totalArea: {
          type: 'string',
          title: 'Total Area (hectares)'
        },
        hifFundingAmount: {
          type: 'string',
          title: 'HIF Funding Amount (£)',
          laReadOnly: true,
          currency: true
        },
        descriptionOfInfrastructure: {
          type: 'string',
          laReadOnly: true,
          title: 'Description of HIF Infrastructure to be delivered'
        },
        descriptionOfWiderProjectDeliverables: {
          type: 'string',
          laReadOnly: true,
          title: 'Description of wider project deliverables'
        }
      },
      required: %w[jointBidAreas totalArea]
    }
  end

  def self.hif_s151
    {
      type: 'object',
      title: 'Section 151',
      properties: {
        s151FundingEndDate: {
          type: 'string',
          format: 'date',
          title: 'HIF Funding End Date'
        },
        s151ProjectLongstopDate: {
          type: 'string',
          format: 'date',
          title: 'Project Longstop date'
        }
      }
    }
  end

  def self.outputs_forecast
    {
      type: 'object',
      title: 'Outputs - Forecast',
      properties: {
        totalUnits: {
          type: 'string',
          laReadOnly: true,
          title: 'Total Units'
        },
        disposalStrategy: {
          type: 'string',
          title: 'Disposal Strategy / Critical Path'
        },
        housingForecast: {
          type: 'array',
          title: 'Housing Forecast',
          items: {
            title: 'Forecast',
            type: 'object',
            properties: {
              period: {
                type: 'string',
                title: 'Period'
              },
              target: {
                type: 'string',
                title: 'Housing Starts'
              },
              housingCompletions: {
                type: 'string',
                title: 'Housing Completions'
              }
            },
            required: %w[period target housingCompletions]
          }
        }
      },
      required: %w[disposalStrategy]
    }
  end

  def self.outputs_actuals
    {
      type: 'object',
      title: 'Outputs - Actual',
      properties: {
        siteOutputs: {
          type: 'array',
          title: 'Site Outputs',
          items: {
            title: 'Output',
            type: 'object',
            properties: {
              siteName: {
                type: 'string',
                title: 'Name of site'
              },
              siteLocalAuthority: {
                type: 'string',
                title: 'Local Authority'
              },
              siteNumberOfUnits: {
                type: 'string',
                title: 'Number of Units'
              }
            },
            required: %w[siteName siteLocalAuthority siteNumberOfUnits]
          }
        }
      }
    }
  end

  def self.rm_baseline
    {
      type: 'object',
      title: 'RM Baseline',
      properties: {
        heContacts: {
          type: 'object',
          title: 'Homes England Contacts',
          properties: {
            relationshipManager: {
              type: 'string',
              title: 'Relationship Manager'
            },
            projectAssuranceManager: {
              type: 'string',
              title: 'Project Assurance Manager'
            }
          }
        },
        strategicLinks: {
          type: 'object',
          title: 'Strategic Links',
          properties: {
            heProgrammeLinks: {
              type: 'object',
              title: 'Links with Homes England Programmes',
              properties: {
                programmes: {
                  type: 'string',
                  title: 'Programmes',
                  enum: [
                    'Accelerated Construction',
                    'Accelerated Land Disposal',
                    'Affordable Homes Programme',
                    'Build to Rent',
                    'City Deals',
                    'Economic Assets',
                    'Estate Regeneration',
                    'Get Britain Building',
                    'Local Infrastructure Fund',
                    'Pilot Transfer',
                    'Property and Regeneration',
                    'Public Land Investment Fund',
                    'Public Sector Land Acquisitions',
                    'Single Land',
                    'THBF - Long Term Fund',
                    'THBF - Short Term Fund'
                  ]
                },
                description: {
                  type: 'string',
                  title: 'Description'
                },
                pcsRef: {
                  type: 'string',
                  title: 'PCS Reference'
                }
              }
            },
            mhclgLinks: {
              type: 'object',
              title: 'Links with other MHCLG Programmes',
              properties: {
                programmes: {
                  type: 'string',
                  title: 'Programmes',
                  enum: [
                    'Accelerated Construction',
                    'Accelerated Land Disposal',
                    'Affordable Homes Programme',
                    'Build to Rent',
                    'City Deals',
                    'Economic Assets',
                    'Estate Regeneration',
                    'Get Britain Building',
                    'Local Infrastructure Fund',
                    'Pilot Transfer',
                    'Property and Regeneration',
                    'Public Land Investment Fund',
                    'Public Sector Land Acquisitions',
                    'Single Land',
                    'THBF - Long Term Fund',
                    'THBF - Short Term Fund'
                  ]
                },
                description: {
                  type: 'string',
                  title: 'Description'
                }
              }
            },
            ogdLinks: {
              type: 'object',
              title: 'Links with OGB programmes',
              properties: {
                programmes: {
                  type: 'string',
                  title: 'Programmes',
                  enum: [
                    'NPIF',
                    'Growth and Housing Fund',
                    'RIS',
                    'RIS2',
                    'Other'
                  ]
                },
                description: {
                  type: 'string',
                  title: 'Description'
                }
              }
            },
            otherGovDepts: {
              type: 'object',
              title: 'Other Government Deparments interested',
              properties: {
                departments: {
                  type: 'string',
                  title: 'Departments',
                  enum: %w[
                    DfT
                    MHCLG
                    BEIS
                    DECC
                    DEFRA
                    DfE
                    DH
                    HMT
                    MOD
                  ]
                },
                description: {
                  type: 'string',
                  title: 'Description'
                }
              }
            },
            housingPolicyAreas: {
              type: 'object',
              title: 'Housing Policy Areas',
              properties: {
                policies: {
                  type: 'string',
                  title: 'Housing Policy Areas',
                  enum: [
                    'Custom Builds',
                    'Modern Method of Construction',
                    'SME',
                    'Garden Towns / Villages / Communities',
                    'Public Sector Land',
                    'Housing Zones',
                    'Accelerated Construction',
                    'Housing Deal',
                    'Brownfield Land',
                    'Large Development'
                  ]
                },
                description: {
                  type: 'string',
                  title: 'Description'
                }
              }
            }
          }
        },
        laContacts: {
          type: 'object',
          title: 'LA Contacts',
          properties: {
            laLead: {
              type: 'object',
              title: 'LA Lead Contact',
              properties: {
                name: {
                  type: 'string',
                  title: 'Name'
                },
                email: {
                  type: 'string',
                  title: 'Email',
                  format: 'email'
                }
              }
            },
            laSupporting: {
              type: 'array',
              title: 'LA Supporting Contacts',
              addable: true,
              items: {
                title: 'Contacts',
                type: 'object',
                properties: {
                  name: {
                    type: 'string',
                    title: 'Name'
                  },
                  email: {
                    type: 'string',
                    title: 'Email',
                    format: 'email'
                  }
                }
              }
            },
            laS151: {
              type: 'object',
              title: 'LA S151 Officer',
              properties: {
                name: {
                  type: 'string',
                  title: 'Name'
                },
                email: {
                  type: 'string',
                  title: 'Email'
                }
              }
            }
          }
        }
      }
    }
  end
end
