require 'json'

class LocalAuthority::Gateway::HIFReturnsSchemaTemplate
  def execute
    @return_template = Common::Domain::Template.new.tap do |p|
      p.schema = {
        title: 'HIF Project',
        type: 'object',
        properties: {
          infrastructures: {
            type: 'array',
            title: 'Infrastructures',
            items: {
              title: 'Infrastructure',
              type: 'object',
              properties: {
                summary: {
                  type: 'object',
                  title: 'Summary',
                  properties: {
                    type: {
                      type: 'string',
                      title: 'Type',
                      sourceKey: %i[baseline_data infrastructures type],
                      readonly: true
                    },
                    description: {
                      type: 'string',
                      title: 'Description',
                      sourceKey: %i[baseline_data infrastructures description],
                      readonly: true
                    },
                    housingSitesBenefitting: {
                      type: "string",
                      title: "Housing Sites Benefitting",
                      sourceKey: %i[baseline_data infrastructures housingSitesBenefitting],
                      readonly: true
                    }
                  }
                },
                planning: {
                  type: 'object',
                  title: 'Planning',
                  properties: {
                    outlinePlanning: {
                      type: 'object',
                      title: 'Outline Planning',
                      properties: {
                        baselineOutlinePlanningPermissionGranted: {
                          type: 'string',
                          title: 'Outline Planning Permission granted',
                          sourceKey: %i[baseline_data infrastructures outlinePlanningStatus granted],
                          readonly: true,
                          radio: true,
                          enum: %w[Yes No N/A]
                        }
                      },
                      dependencies: {
                        baselineOutlinePlanningPermissionGranted: {
                          oneOf: [
                            {
                              properties: {
                                baselineOutlinePlanningPermissionGranted: {
                                  enum: ['No']
                                },
                                baselineSummaryOfCriticalPath: {
                                  type: 'string',
                                  title: 'Summary Of Outline Planning Permission Critical Path',
                                  sourceKey: %i[baseline_data infrastructures outlinePlanningStatus summaryOfCriticalPath],
                                  readonly: true
                                },
                                planningSubmitted: {
                                  title: 'Planning Permission Submitted',
                                  type: 'object',
                                  variance: true,
                                  required: ['percentComplete'],
                                  properties: {
                                    targetDateOfAchievingStart: {
                                      type: 'string',
                                      title: 'Start on Site',
                                      sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                                      hidden: true,
                                      readonly: true
                                    },
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission submitted date',
                                      sourceKey: %i[baseline_data infrastructures outlinePlanningStatus targetSubmission],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Baseline Submitted Date (weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Last Return Submitted Date (weeks) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status Against Last Return?',
                                      type: 'string',
                                      radio: true,
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningSubmitted status],
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    previousReturn: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningSubmitted current
                                      ]
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'string',
                                      title: 'Percent Complete',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningSubmitted percentComplete],
                                      percentage: true
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningSubmitted completedDate],
                                      title: 'Completed Date (Calculated)'
                                    },
                                    onCompletedReference: {
                                      type: 'string',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningSubmitted onCompletedReference],
                                      title: 'Completed Reference (Calculated)'
                                    }
                                  }
                                },
                                planningGranted: {
                                  title: 'Planning Permission Granted',
                                  type: 'object',
                                  variance: true,
                                  properties: {
                                    targetDateOfAchievingStart: {
                                      type: 'string',
                                      title: 'Start on Site',
                                      sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                                      hidden: true,
                                      readonly: true
                                    },
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Outline Planning Permission granted date',
                                      sourceKey: %i[baseline_data infrastructures outlinePlanningStatus targetGranted],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Baseline Granted Date (weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Last Return Granted Date (weeks) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      radio: true,
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningGranted status],
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    previousReturn: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningGranted current
                                      ]
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'string',
                                      title: 'Percent Complete',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningGranted percentComplete],
                                      percentage: true
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning outlinePlanning planningGranted completedDate],
                                      title: 'Completed Date (Calculated)'
                                    }
                                  }
                                }
                              }
                            },
                            {
                              properties: {
                                baselineOutlinePlanningPermissionGranted: {
                                  enum: ['Yes']
                                },
                                reference: {
                                  type: "string",
                                  title: "Reference",
                                  readonly: true,
                                  sourceKey: %i[baseline_data infrastructures outlinePlanningStatus reference],
                                }
                              }
                            },
                            {
                              properties: {
                                baselineOutlinePlanningPermissionGranted: {
                                  enum: ['N/A']
                                }
                              }
                            }
                          ]
                        }
                      }
                    },
                    fullPlanning: {
                      type: 'object',
                      title: 'Full Planning',
                      properties: {
                        fullPlanningPermissionGranted: {
                          type: 'string',
                          title: 'Full Planning Permission granted',
                          sourceKey: %i[baseline_data infrastructures fullPlanningStatus granted],
                          readonly: true,
                          radio: true,
                          enum: %w[Yes No N/A]
                        }
                      },
                      dependencies: {
                        fullPlanningPermissionGranted: {
                          oneOf: [
                            {
                              type: 'object',
                              properties: {
                                fullPlanningPermissionGranted: {
                                  enum: ['No']
                                },
                                fullPlanningPermissionSummaryOfCriticalPath: {
                                  type: 'string',
                                  title: 'Summary Of Full Planning Permission Critical Path',
                                  sourceKey: %i[baseline_data infrastructures fullPlanningStatus summaryOfCriticalPath],
                                  readonly: true
                                },
                                submitted: {
                                  title: 'Planning permission Submitted',
                                  type: 'object',
                                  variance: true,
                                  properties: {
                                    targetDateOfAchievingStart: {
                                      type: 'string',
                                      title: 'Start on Site',
                                      sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                                      hidden: true,
                                      readonly: true
                                    },
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission submitted date',
                                      sourceKey: %i[baseline_data infrastructures fullPlanningStatus targetSubmission],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Baseline Submitted Date (week) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Last Return Submitted Date (week) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      radio: true,
                                      sourceKey: %i[return_data infrastructures planning fullPlanning submitted status],
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    previousReturn: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning fullPlanning submitted current
                                      ]
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'string',
                                      title: 'Percent Complete',
                                      sourceKey: %i[return_data infrastructures planning fullPlanning submitted percentComplete],
                                      percentage: true
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      sourceKey: %i[return_data infrastructures planning fullPlanning submitted completedDate],
                                      title: 'Completed Date (Calculated)'
                                    },
                                    onCompletedReference: {
                                      type: 'string',
                                      readonly: true,
                                      sourceKey: %i[return_data infrastructures planning fullPlanning submitted onCompletedReference],
                                      title: 'Completed Reference (Calculated)'
                                    }
                                  }
                                },
                                granted: {
                                  title: 'Planning Permission Granted',
                                  type: 'object',
                                  variance: true,
                                  properties: {
                                    targetDateOfAchievingStart: {
                                      type: 'string',
                                      title: 'Start on Site',
                                      sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                                      hidden: true,
                                      readonly: true
                                    },
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission granted date',
                                      sourceKey: %i[baseline_data infrastructures fullPlanningStatus targetGranted],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Baseline Granted Date (weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance Against Last Return Granted Date (weeks) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      radio: true,
                                      sourceKey: %i[return_data infrastructures planning fullPlanning granted status],
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    previousReturn: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning fullPlanning granted current
                                      ]
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'string',
                                      title: 'Percent Complete',
                                      sourceKey: %i[return_data infrastructures planning fullPlanning granted percentComplete],
                                      percentage: true
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      sourceKey: %i[return_data infrastructures planning fullPlanning granted completedDate],
                                      title: 'Completed Date (Calculated)'
                                    }
                                  }
                                }
                              }
                            },
                            {
                              properties: {
                                fullPlanningPermissionGranted: {
                                  enum: ['Yes']
                                },
                                reference: {
                                  type: "string",
                                  title: "Reference",
                                  readonly: true,
                                  sourceKey: %i[baseline_data infrastructures fullPlanningStatus grantedReference],
                                }
                              }
                            },
                            {
                              properties: {
                                fullPlanningPermissionGranted: {
                                  enum: ['N/A']
                                }
                              }
                            }
                          ]
                        }
                      }
                    },
                    section106: {
                      title: 'Section 106',
                      type: 'object',
                      properties: {
                        # from s106.requirement
                        s106Requirement: {
                          type: 'string',
                          title: 'S106 Requirement',
                          sourceKey: %i[baseline_data infrastructures s106 requirement],
                          readonly: true,
                          items: {
                            type: 'string',
                            radio: true,
                            enum: %w[Yes No]
                          }
                        }
                      },
                      dependencies: {
                        s106Requirement: {
                          oneOf: [
                            {
                              properties: {
                                s106Requirement: {
                                  enum: ['Yes']
                                },
                                s106SummaryOfRequirement: {
                                  type: 'string',
                                  title: 'Summary of S016 Requirement ',
                                  sourceKey: %i[baseline_data infrastructures s106 summaryOfRequirement],
                                  readonly: true
                                },
                                # from statutoryConsents.anyConsents
                                statutoryConsents: {
                                  type: 'object',
                                  title: 'Statutory Consents',
                                  properties: {
                                    anyStatutoryConsents: {
                                      type: 'string',
                                      title: 'Statutory consents to be met?',
                                      sourceKey: %i[baseline_data infrastructures statutoryConsents anyConsents],
                                      readonly: true,
                                      items: {
                                        type: 'string',
                                        radio: true,
                                        enum: %w[Yes No]
                                      }
                                    },
                                    statutoryConsents: {
                                      title: 'Status of Statutory Consents',
                                      type: 'array',
                                      items: {
                                        type: 'object',
                                        properties: {
                                          detailsOfConsent: {
                                            title: 'Details of Consent',
                                            type: 'string',
                                            readonly: true,
                                            sourceKey: %i[baseline_data infrastructures statutoryConsents consents detailsOfConsent]
                                          },
                                          baselineCompletion: {
                                            title: 'Baseline Target',
                                            type: 'string',
                                            format: 'date',
                                            sourceKey: %i[baseline_data infrastructures statutoryConsents consents targetDateToBeMet],
                                            readonly: true
                                          },
                                          varianceAgainstBaseline: {
                                            hidden: true,
                                            title: 'Variance Against Baseline (weeks) (Calculated)',
                                            type: 'string',
                                            readonly: true
                                          },
                                          varianceAgainstLastReturn: {
                                            hidden: true,
                                            title: 'Variance Against Last Return (weeks) (Calculated)',
                                            type: 'string',
                                            readonly: true
                                          },
                                          statusAgainstLastReturn: {
                                            title: 'Status against last return?',
                                            type: 'string',
                                            radio: true,
                                            enum: [
                                              'Completed',
                                              'On schedule',
                                              'Delayed - minimal impact',
                                              'Delayed - moderate impact',
                                              'Delayed - critical'
                                            ],
                                            sourceKey: %i[return_data infrastructures planning section106 statutoryConsents statutoryConsents statusAgainstLastReturn]
                                          },
                                          currentReturn: {
                                            title: 'Current return',
                                            type: 'string',
                                            format: 'date'
                                          },
                                          previousReturn: {
                                            title: 'Previous Return',
                                            readonly: true,
                                            type: 'string',
                                            format: 'date',
                                            sourceKey: %i[return_data infrastructures planning section106 statutoryConsents statutoryConsents currentReturn]
                                          },
                                          varianceReason: {
                                            title: 'Reason for Variance',
                                            type: 'string'
                                          },
                                          percentComplete: {
                                            title: 'Percentage Complete',
                                            type: 'string',
                                            percentage: true,
                                            sourceKey: %i[return_data infrastructures planning section106 statutoryConsents statutoryConsents percentComplete]
                                          },
                                          completionDate: {
                                            hidden: true,
                                            title: 'Completion Date (Calculated)',
                                            type: 'string',
                                            format: 'date',
                                            sourceKey: %i[return_data infrastructures planning section106 statutoryConsents statutoryConsents completionDate],
                                            readonly: true
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            {
                              properties: {
                                s106Requirement: {
                                  enum: ['No']
                                }
                              }
                            }
                          ]
                        }
                      }
                    }
                  }
                },
                landOwnership: {
                  type: 'object',
                  title: 'Land Ownership',
                  properties: {
                    # from landOwnership.underControlOfLA
                    laHasControlOfSite: {
                      type: 'string',
                      title: 'LA Control of site(s) (related to infrastructure)? ',
                      sourceKey: %i[baseline_data infrastructures landOwnership underControlOfLA],
                      readonly: true,
                      radio: true,
                      enum: %w[Yes No]
                    }
                  },
                  dependencies: {
                    laHasControlOfSite: {
                      oneOf: [
                        {
                          properties: {
                            laHasControlOfSite: {
                              enum: ['No']
                            },
                            laDoesNotControlSite: {
                              type: 'object',
                              title: 'Land ownership',
                              properties: {
                                # from  landOwnership.ownershipOfLandOtherThanLA
                                whoOwnsSite: {
                                  type: 'string',
                                  title: 'Who owns site?',
                                  sourceKey: %i[baseline_data infrastructures landOwnership ownershipOfLandOtherThanLA],
                                  readonly: true
                                },
                                # from landOwnership.landAcquisitionRequired
                                landAcquisitionRequired: {
                                  type: 'string',
                                  title: 'Land acquisition required (related to infrastructure)?',
                                  sourceKey: %i[baseline_data infrastructures landOwnership isLandAcquisitionRequired],
                                  readonly: true,
                                  radio: true,
                                  enum: %w[Yes No]
                                }
                              },
                              dependencies: {
                                landAcquisitionRequired: {
                                  oneOf: [
                                    {
                                      properties: {
                                        landAcquisitionRequired: {
                                          enum: ['Yes']
                                        },
                                        howManySitesToAquire: {
                                          type: 'string',
                                          title: 'Number of Sites to aquire?',
                                          sourceKey: %i[baseline_data infrastructures landOwnership sitesToAcquire],
                                          readonly: true
                                        },
                                        # from landOwnership.toBeAquiredBy
                                        toBeAquiredBy: {
                                          type: 'string',
                                          title: 'Acquired by LA or Developer?',
                                          sourceKey: %i[baseline_data infrastructures landOwnership acquiredBy],
                                          readonly: true
                                        },
                                        # from landOwnership.summaryOfCriticalPath
                                        summaryOfAcquisitionRequired: {
                                          type: 'string',
                                          title: 'Summary of acquisition required',
                                          sourceKey: %i[baseline_data infrastructures landOwnership criticalPath],
                                          readonly: true
                                        },
                                        allLandAssemblyAchieved: {
                                          type: 'object',
                                          title: 'All land assembly achieved',
                                          variance: true,
                                          properties: {
                                            # from landOwnership.toBeAquiredBy
                                            baseline: {
                                              type: 'string',
                                              format: 'date',
                                              title: 'Baseline Target',
                                              sourceKey: %i[baseline_data infrastructures landOwnership dateToAcquire],
                                              readonly: true
                                            },
                                            previousReturn: {
                                              type: 'string',
                                              sourceKey: %i[return_data infrastructures landOwnership laDoesNotControlSite allLandAssemblyAchieved current],
                                            },
                                            # To be calculated
                                            landAssemblyVarianceAgainstLastReturn: {
                                              type: 'string',
                                              readonly: true,
                                              hidden: true,
                                              title: 'Variance Against Last Return (weeks) (Calculated)'
                                            },
                                            # To be calculated
                                            landAssemblyVarianceAgainstBaseReturn: {
                                              type: 'string',
                                              readonly: true,
                                              hidden: true,
                                              title: 'Variance Against Base Return (weeks) (Calculated)'
                                            },
                                            status: {
                                              title: 'Status against last return?',
                                              type: 'string',
                                              radio: true,
                                              sourceKey: %i[return_data infrastructures landOwnership laDoesNotControlSite allLandAssemblyAchieved status],
                                              enum: [
                                                'Completed',
                                                'On schedule',
                                                'Delayed'
                                              ],
                                              default: 'On schedule'
                                            },
                                            current: {
                                              type: 'string',
                                              format: 'date',
                                              title: 'Current Return'
                                            },
                                            reason: {
                                              type: 'string',
                                              title: 'Reason for Variance'
                                            },
                                            percentComplete: {
                                              type: 'string',
                                              title: 'Percent Complete',
                                              sourceKey: %i[return_data infrastructures landOwnership laDoesNotControlSite allLandAssemblyAchieved percentComplete],
                                              percentage: true
                                            },
                                            completedDate: {
                                              type: 'string',
                                              format: 'date',
                                              sourceKey: %i[return_data infrastructures landOwnership laDoesNotControlSite allLandAssemblyAchieved completedDate],
                                              title: 'On Completed Date'
                                            }
                                          }
                                        }
                                      }
                                    },
                                    {
                                      properties: {
                                        landAcquisitionRequired: {
                                          enum: ['No']
                                        }
                                      }
                                    }
                                  ]
                                }
                              }
                            }
                          }
                        },
                        {
                          properties: {
                            laHasControlOfSite: {
                              enum: ['Yes']
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
                      title: 'Infrastructure contractor procured?',
                      sourceKey: %i[baseline_data infrastructures procurement contractorProcured],
                      readonly: true,
                      items: {
                        type: 'string',
                        radio: true,
                        enum: %w[Yes No]
                      }
                    }
                  },
                  dependencies: {
                    contractorProcured: {
                      oneOf: [
                        {
                          properties: {
                            contractorProcured: {
                              enum: ['Yes']
                            },
                            nameOfContractor: {
                              sourceKey: %i[baseline_data infrastructures procurement nameOfContractor],
                              type: 'string',
                              title: 'Name of Contractor',
                              readonly: true
                            }
                          }
                        },
                        {
                          properties: {
                            contractorProcured: {
                              enum: ['No']
                            },
                            summaryOfCriticalPath: {
                              sourceKey: %i[baseline_data infrastructures procurement summaryOfCriticalPath],
                              type: 'string',
                              title: 'Summary of Critical Procurement Path',
                              readonly: true,
                              extendedText: true
                            },
                            procurementBaselineCompletion: {
                              type: 'string',
                              format: 'date',
                              title: 'Target Date of Procuring',
                              sourceKey: %i[baseline_data infrastructures procurement targetDate],
                              readonly: true
                            },
                            procurementVarianceAgainstLastReturn: {
                              type: 'string',
                              readonly: true,
                              hidden: true,
                              title: 'Variance Against Last Return (weeks) (Calculated)'
                            },
                            procurementVarianceAgainstBaseline: {
                              type: 'string',
                              readonly: true,
                              hidden: true,
                              title: 'Variance Against Baseline (weeks) (Calculated)'
                            },
                            procurementStatusAgainstLastReturn: {
                              type: 'object',
                              title: 'Procurement Status Against Last Return',
                              properties: {
                                targetDateOfAchievingStart: {
                                  type: 'string',
                                  title: 'Start on Site',
                                  sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                                  hidden: true,
                                  readonly: true
                                },
                                statusAgainstLastReturn: {
                                  title: 'Status Against Last Return?',
                                  type: 'string',
                                  radio: true,
                                  sourceKey: %i[return_data infrastructures procurement procurementStatusAgainstLastReturn statusAgainstLastReturn],
                                  enum: [
                                    'Completed',
                                    'On schedule',
                                    'Delayed'
                                  ],
                                  default: 'On schedule'
                                },
                                currentReturn: {
                                  type: 'string',
                                  format: 'date',
                                  title: 'Current expected date of Procurement'
                                },
                                reasonForVariance: {
                                  type: 'string',
                                  title: 'Reason for Variance'
                                },
                                previousReturn: {
                                  type: "string",
                                  sourceKey: %i[return_data infrastructures procurement procurementStatusAgainstLastReturn currentReturn]
                                }
                              }
                            },
                            percentComplete: {
                              type: 'string',
                              title: 'Percent Complete',
                              percentage: true
                            },
                            procurementCompletedDate: {
                              type: 'string',
                              title: 'Completion Date',
                              sourceKey: %i[return_data infrastructures procurement procurementCompletedDate]
                            },
                            procurementCompletedNameOfContractor: {
                              type: 'string',
                              title: 'Completion Name of Contractor',
                              sourceKey: %i[return_data infrastructures procurement procurementCompletedNameOfContractor]
                            }
                          }
                        }
                      ]
                    }
                  }
                },
                milestones: {
                  type: 'object',
                  title: 'Milestones',
                  properties: {
                    keyMilestones: {
                      type: 'array',
                      title: 'Key Project Milestones',
                      items: {
                        type: 'object',
                        milestone: true,
                        properties: {
                          description: {
                            sourceKey: %i[baseline_data infrastructures milestones descriptionOfMilestone],
                            readonly: true,
                            type: 'string',
                            title: 'Description'
                          },
                          milestoneBaselineCompletion: {
                            sourceKey: %i[baseline_data infrastructures milestones target],
                            readonly: true,
                            type: 'string',
                            format: 'date',
                            title: 'Completion Date'
                          },
                          milestoneLastReturnDate:{
                            type: "string",
                            sourceKey: %i[return_data infrastructures milestones keyMilestones currentReturn]
                          },
                          # from milestones.summaryOfCriticalPath
                          milestoneSummaryOfCriticalPath: {
                            sourceKey: %i[baseline_data infrastructures milestones summaryOfCriticalPath],
                            type: 'string',
                            title: 'Summary of Baseline Critical Path',
                            readonly: true
                          },
                          milestoneVarianceAgainstLastReturn: {
                            type: 'string',
                            readonly: true,
                            title: 'Variance Against Last Return (Calculated)'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            title: 'Variance Against Baseline (Calculated)'
                          },
                          statusAgainstLastReturn: {
                            title: 'Status against last return?',
                            type: 'string',
                            sourceKey: %i[return_data infrastructures milestones keyMilestones statusAgainstLastReturn],
                            radio: true,
                            enum: [
                              'Completed',
                              'On schedule',
                              'Delayed'
                            ],
                            default: 'On schedule'
                          },
                          currentReturn: {
                            type: 'string',
                            format: 'date',
                            title: 'Current Return'
                          },
                          reasonForVariance: {
                            type: 'string',
                            title: 'Reason for Variance'
                          },
                          milestonePercentCompleted: {
                            type: 'string',
                            title: 'Percent complete',
                            percentage: true
                          },
                          milestoneCompletedDate: {
                            type: 'string',
                            format: 'date',
                            sourceKey: %i[return_data infrastructures milestones keyMilestones milestoneCompletedDate],
                            title: 'On Completed Date'
                          }
                        }
                      }
                    },
                    additionalMilestones: {
                      type: 'array',
                      title: 'Additional Milestones',
                      addable: true,
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          # from milestones.target
                          description: {
                            type: 'string',
                            title: 'Description'
                          },
                          milestoneBaselineCompletion: {
                            type: 'string',
                            format: 'date',
                            title: 'Target date of completion'
                          },
                          # from milestones.summaryOfCriticalPath
                          milestoneSummaryOfCriticalPath: {
                            type: 'string',
                            title: 'Summary of Critical Path'
                          }
                        }
                      }
                    },
                    previousMilestones: {
                      type: 'array',
                      title: 'Previous Milestones',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          # from milestones.target
                          description: {
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones description],
                            readonly: true,
                            type: 'string',
                            title: 'Description'
                          },
                          milestoneBaselineCompletion: {
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones milestoneBaselineCompletion],
                            readonly: true,
                            type: 'string',
                            format: 'date',
                            title: 'Completion Date'
                          },
                          # from milestones.summaryOfCriticalPath
                          milestoneSummaryOfCriticalPath: {
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones milestoneSummaryOfCriticalPath],
                            type: 'string',
                            title: 'Summary of Baseline Critical Path',
                            readonly: true
                          },
                          milestoneLastReturnDate: {
                            type: 'string',
                            title: 'Last Return Date',
                            hidden: true,
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones currentReturn]
                          },
                          milestoneVarianceAgainstLastReturn: {
                            type: 'string',
                            readonly: true,
                            hidden: true,
                            title: 'Variance Against Last Return (weeks) (Calculated)'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            hidden: true,
                            title: 'Variance Against Baseline (weeks) (Calculated)'
                          },
                          statusAgainstLastReturn: {
                            title: 'Status against last return?',
                            type: 'string',
                            radio: true,
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones statusAgainstLastReturn],
                            enum: [
                              'Completed',
                              'On schedule',
                              'Delayed'
                            ],
                            default: 'On schedule'
                          },
                          currentReturn: {
                            type: 'string',
                            format: 'date',
                            title: 'Current Return'
                          },
                          reasonForVariance: {
                            type: 'string',
                            title: 'Reason for Variance'
                          },
                          milestonePercentCompleted: {
                            type: 'string',
                            title: 'Percent Complete',
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones milestonePercentCompleted],
                            percentage: true
                          },
                          milestoneCompletedDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            sourceKey: %i[return_data infrastructures milestones cumulativeadditionalMilestones milestoneCompletedDate],
                            hidden: true,
                            title: 'On Completed Date (Calculated)'
                          }
                        }
                      }
                    },
                    expectedInfrastructureStartOnSite: {
                      type: 'object',
                      title: 'Expected Infrastructure Start on Site',
                      variance: true,
                      properties: {
                        baseline: {
                          # from milestones.expectedInfrastructureStart
                          sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                          type: 'string',
                          title: 'Baseline Start on site',
                          readonly: true
                        },
                        previousReturn: {
                          type: "string",
                          sourceKey: %i[return_data infrastructures milestones expectedInfrastructureStartOnSite current],
                        },
                        varianceAgainstLastReturn: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance Against Last Return (weeks) (Calculated)'
                        },
                        varianceAgainstBaseline: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance Against Baseline (weeks) (Calculated)'
                        },
                        status: {
                          title: 'Status against last return?',
                          type: 'string',
                          radio: true,
                          sourceKey: %i[return_data infrastructures milestones expectedInfrastructureStartOnSite status],
                          enum: [
                            'Completed',
                            'On schedule',
                            'Delayed'
                          ],
                          default: 'On schedule'
                        },
                        current: {
                          type: 'string',
                          format: 'date',
                          title: 'Current Return'
                        },
                        reason: {
                          type: 'string',
                          title: 'Reason for variance'
                        },
                        percentComplete: {
                          type: 'string',
                          title: 'Percent complete',
                          perentage: true
                        },
                        completedDate: {
                          type: 'string',
                          format: 'date',
                          sourceKey: %i[return_data infrastructures milestones expectedInfrastructureStartOnSite completedDate],
                          title: 'Completed Date'
                        }
                      }
                    },
                    expectedCompletionDateOfInfra: {
                      type: 'object',
                      title: 'Expected Completion date of infra',
                      variance: true,
                      properties: {
                        baseline: {
                          # from milestones.expectedInfrastructureStart
                          sourceKey: %i[baseline_data infrastructures expectedInfrastructureCompletion targetDateOfAchievingCompletion],
                          type: 'string',
                          format: 'date',
                          title: 'Baseline date of Completion',
                          readonly: true
                        },
                        previousReturn: {
                          type: "string",
                          sourceKey: %i[return_data infrastructures milestones expectedCompletionDateOfInfra current],
                        },
                        varianceAgainstLastReturn: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance Against Last Return (weeks) (Calculated)'
                        },
                        varianceAgainstBaseline: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance Against Baseline (weeks) (Calculated)'
                        },
                        status: {
                          title: 'Status against last return?',
                          type: 'string',
                          sourceKey: %i[return_data infrastructures milestones expectedCompletionDateOfInfra status],
                          radio: true,
                          enum: [
                            'Completed',
                            'On schedule',
                            'Delayed'
                          ],
                          default: 'On schedule'
                        },
                        current: {
                          type: 'string',
                          format: 'date',
                          title: 'Current Return'
                        },
                        reason: {
                          type: 'string',
                          title: 'Reason for variance'
                        },
                        percentComplete: {
                          type: 'string',
                          title: 'Percent complete',
                          percentage: true
                        },
                        completedDate: {
                          type: 'string',
                          format: 'date',
                          sourceKey: %i[return_data infrastructures milestones expectedCompletionDateOfInfra completedDate],
                          title: 'Completed Date'
                        }
                      }
                    }
                  }
                },
                risks: {
                  type: 'object',
                  title: 'Risks',
                  properties: {
                    baselineRisks: {
                      type: 'array',
                      title: 'Baseline Risks',
                      items: {
                        type: 'object',
                        risk: true,
                        properties: {
                          riskBaselineRisk: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales descriptionOfRisk],
                            type: 'string',
                            title: 'Description Of Risk',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.impactOfRisk
                          riskBaselineImpact: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales impactOfRisk],
                            type: 'string',
                            title: 'Impact',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.likelihoodOfRisk
                          riskBaselineLikelihood: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales likelihoodOfRisk],
                            type: 'string',
                            title: 'Likelihood',
                            readonly: true
                          },
                          riskCurrentReturnLikelihood: {
                            type: 'string',
                            title: 'Current Return Likelihood'
                          },
                          # from risksToAchievingTimescales.mitigationOfRisk
                          riskBaselineMitigationsInPlace: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales mitigationOfRisk],
                            type: 'string',
                            title: 'Mitigation in place',
                            readonly: true
                          },
                          riskAnyChange: {
                            type: 'string',
                            title: 'Any Change in Risk?',
                            radio: true,
                            enum: %w[Yes No]
                          },
                          riskCurrentReturnMitigationsInPlace: {
                            type: 'string',
                            title: 'Current Return Mitigations in Place'
                          },
                          riskMetDate: {
                            type: 'string',
                            enum: %w[Yes No],
                            title: 'Risk Met?',
                            sourceKey: %i[return_data infrastructures risks baselineRisks riskMetDate]
                          },
                          riskCompletionDate: {
                            type: 'string',
                            format: 'date',
                            title: 'Completion Date',
                            sourceKey: %i[return_data infrastructures risks baselineRisks riskCompletionDate]
                          }
                        }
                      }
                    },
                    additionalRisks: {
                      type: 'array',
                      title: 'Any Additional Risks to Baseline?',
                      addable: true,
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          description: {
                            type: 'string',
                            title: 'Description'
                          },
                          impact: {
                            type: 'string',
                            title: 'Impact'
                          },
                          likelihood: {
                            type: 'string',
                            title: 'Likelihood'
                          },
                          mitigations: {
                            type: 'string',
                            title: 'Mitigations in place'
                          }
                        }
                      }
                    },
                    cumulativeadditionalRisks: {
                      type: 'array',
                      title: ' ',
                      items: {
                        type: 'object',
                        properties: {
                          description: {
                            type: 'string',
                            title: 'Description',
                            hidden: true
                          },
                          impact: {
                            type: 'string',
                            title: 'Impact',
                            hidden: true
                          },
                          likelihood: {
                            type: 'string',
                            title: 'Likelihood',
                            hidden: true
                          },
                          mitigations: {
                            type: 'string',
                            title: 'Mitigations in place',
                            hidden: true
                          }
                        }
                      }
                    },
                    previousRisks: {
                      type: 'array',
                      title: 'Previous Risks',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          riskBaselineRisk: {
                            sourceKey: %i[return_data infrastructures risks cumulativeadditionalRisks description],
                            type: 'string',
                            title: 'Description Of Risk',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.impactOfRisk
                          riskBaselineImpact: {
                            sourceKey: %i[return_data infrastructures risks cumulativeadditionalRisks impact],
                            type: 'string',
                            title: 'Impact',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.likelihoodOfRisk
                          riskBaselineLikelihood: {
                            sourceKey: %i[return_data infrastructures risks cumulativeadditionalRisks likelihood],
                            type: 'string',
                            title: 'Likelihood',
                            readonly: true
                          },
                          riskCurrentReturnLikelihood: {
                            type: 'string',
                            title: 'Current Return Likelihood'
                          },
                          # from risksToAchievingTimescales.mitigationOfRisk
                          riskBaselineMitigationsInPlace: {
                            sourceKey: %i[return_data infrastructures risks cumulativeadditionalRisks mitigations],
                            type: 'string',
                            title: 'Mitigation in place',
                            readonly: true
                          },
                          riskAnyChange: {
                            type: 'string',
                            title: 'Any Change in Risk?',
                            radio: true,
                            enum: %w[Yes No]
                          },
                          riskCurrentReturnMitigationsInPlace: {
                            type: 'string',
                            title: 'Current Return Mitigations in Place'
                          },
                          riskMetDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            hidden: true,
                            title: 'Risk Met Date (Calculated)'
                          }
                        }
                      }
                    }
                  }
                },
                progress: {
                  type: 'object',
                  title: 'Progress',
                  properties: {
                    describeQuarterProgress: {
                      type: 'string',
                      title: 'Describe Progress for Last Quarter'
                    },
                    progressAgainstActions: {
                      type: 'array',
                      title: 'Progress Against Actions',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          description: {
                            sourceKey: %i[return_data infrastructures progress carriedForward description],
                            type: 'string',
                            readonly: true,
                            # from actions for next quarter
                            title: 'Description of Live Action (Calculated)'
                          },
                          met: {
                            type: 'string',
                            title: 'Action Met?',
                            radio: true,
                            enum: %w[Yes No]
                          },
                          progress: {
                            type: 'string',
                            title: 'Progress Against Action if not Met'
                          }
                        }
                      }
                    },
                    actionsForNextQuarter: {
                      type: 'array',
                      title: 'Actions for next quarter',
                      addable: true,
                      items: {
                        type: 'object',
                        properties: {
                          description: {
                            type: 'string',
                            title: 'Action Description'
                          }
                        }
                      }
                    },
                    carriedForward: {
                      type: 'array',
                      title: 'Pulled forward',
                      hidden: true,
                      items: {
                        type: 'object',
                        properties: {
                          description: {
                            type: 'string',
                            title: 'Action Description'
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          fundingProfiles: {
            type: 'object',
            title: 'HIF Grant Expenditure',
            properties: {
              totalHIFGrant: {
                type: 'string',
                title: 'Total HIF Grant',
                readonly: true,
                currency: true,
                sourceKey: %i[baseline_data summary hifFundingAmount]
              },
              fundingRequest: {
                type: 'array',
                title: 'Funding Request',
                items: {
                  type: 'object',
                  properties: {
                    period: {
                      title: 'Period',
                      type: 'string',
                      sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :period],[:return_data, :fundingProfiles, :currentFunding, :forecast, :period]],
                      readonly: true
                    },
                    forecast: {
                      title: 'Forecast',
                      type: 'object',
                      horizontal: true,
                      properties: {
                        instalment1: {
                          title: '1st Quarter',
                          type: 'string',
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment1],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment1]],
                          readonly: true,
                          currency: true
                        },
                        instalment2: {
                          title: '2nd Quarter',
                          type: 'string',
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment2],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment2]],
                          readonly: true,
                          currency: true
                        },
                        instalment3: {
                          title: '3rd Quarter',
                          type: 'string',
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment3], [:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment3]],
                          readonly: true,
                          currency: true
                        },
                        instalment4: {
                          title: '4th Quarter',
                          type: 'string',
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment4],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment4]],
                          readonly: true,
                          currency: true
                        },
                        total: {
                          title: 'Total',
                          type: 'string',
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :total],[:return_data, :fundingProfiles, :currentFunding, :forecast, :total]],
                          readonly: true,
                          currency: true
                        }
                      }
                    }
                  }
                }
              },
              currentFunding: {
                type: "object",
                title: " ",
                properties: {
                  forecast: {
                  title: " ",
                  type: "array",
                  quarterly: true,
                    items: {
                      type: "object",
                      properties: {
                        period: {
                          title: "Period",
                          type: "string",
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :period],[:return_data, :fundingProfiles, :currentFunding, :forecast, :period]],
                          hidden: true
                        },
                        instalment1: {
                          title: "1st Quarter",
                          type: "string",
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment1],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment1]],
                          hidden: true
                        },
                        instalment2: {
                          title: "2nd Quarter",
                          type: "string",
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment2],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment2]],
                          hidden: true
                        },
                        instalment3: {
                          title: "3rd Quarter",
                          type: "string",
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment3],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment3]],
                          hidden: true
                        },
                        instalment4: {
                          title: "4th Quarter",
                          type: "string",
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :instalment4],[:return_data, :fundingProfiles, :currentFunding, :forecast, :instalment4]],
                          hidden: true
                        },
                        total: {
                          title: "Total",
                          type: "string",
                          sourceKey: [:return_or_baseline, [:baseline_data, :fundingProfiles, :total],[:return_data, :fundingProfiles, :currentFunding, :forecast, :total]],
                          hidden: true
                        }
                      }
                    }
                  }
                }
              },
              changeRequired: {
                type: 'string',
                title: 'Change Required?',
                description: 'Please confirm there are no changes to be made to the funding profile',
                radio: true,
                enum: ['Confirmed', 'Change required']
              }
            },
            dependencies: {
              changeRequired: {
                oneOf: [
                  {
                    properties: {
                      changeRequired: {
                        enum: ['Change required']
                      },
                      reasonForRequest: {
                        type: 'string',
                        title: 'Reason for request',
                        description: 'Changes to funding profile will need to be agreed by s.151 officer - you will be asked to agree to this on submission.'
                      },
                      mitigationInPlace: {
                        type: 'string',
                        title: 'Mitigation in place to reduce further slippage'
                      },
                      requestedProfiles: {
                        type: 'array',
                        title: 'Funding Request',
                        items: {
                          type: 'object',
                          properties: {
                            period: {
                              title: 'Period',
                              type: 'string',
                              sourceKey: %i[baseline_data fundingProfiles period],
                              readonly: true
                            },
                            newProfile: {
                              title: 'New Profile',
                              type: 'object',
                              horizontal: true,
                              properties: {
                                instalment1: {
                                  title: '1st Quarter',
                                  type: 'string',
                                  currency: true
                                },
                                instalment2: {
                                  title: '2nd Quarter',
                                  type: 'string',
                                  currency: true
                                },
                                instalment3: {
                                  title: '3rd Quarter',
                                  type: 'string',
                                  currency: true
                                },
                                instalment4: {
                                  title: '4th Quarter',
                                  type: 'string',
                                  currency: true
                                },
                                total: {
                                  title: 'Total',
                                  type: 'string',
                                  currency: true
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  {
                    properties: {
                      changeRequired: {
                        enum: ['Confirmed']
                      }
                    }
                  }
                ]
              }
            }
          },
          fundingPackages: {
            type: 'array',
            title: 'Funding Packages',
            items: {
              type: 'object',
              title: 'Funding for Infrastructure',
              properties: {
                descriptionOfInfrastructure: {
                  title: "Description of Infrastructure",
                  type: "string",
                  extendedText: true,
                  readonly: true,
                  sourceKey: %i[baseline_data infrastructures description]
                },
                fundingStack: {
                  type: 'object',
                  title: 'Funding stack',
                  properties: {
                    hifSpendSinceLastReturn: {
                      title: 'HIF Spend Since Last Return',
                      type: 'object',
                      properties: {
                        currentReturn: {
                          title: "Current Return",
                          type: "string",
                          currency: true
                        },
                        cumulativeIncCurrentReturn: {
                          title: "Cumulative Including Current Return",
                          type: "string",
                          currency: true
                        },
                        cumulativeExCurrentReturn: {
                          title: "Cumulative Excluding Current Return",
                          sourceKey: %i[
                            return_data
                            fundingPackages
                            fundingStack
                            hifSpendSinceLastReturn
                            cumulativeIncCurrentReturn
                          ],
                          hidden: true,
                          type: "string",
                          currency: true,
                          readonly: true
                        },
                        remaining: {
                          title: "Remaining",
                          type: "string",
                          currency: true
                        }
                      }
                    },
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
                        currentAmount: {
                          type: 'string',
                          title: '',
                          hidden: true,
                          sourceKey: %i[return_data fundingPackages fundingStack hifSpend currentAmount]
                        },
                        lastReturn: {
                          type: 'string',
                          title: 'Last Return',
                          readonly: true,
                          currency: true,
                          sourceKey: %i[return_data fundingPackages fundingStack hifSpend currentAmount]
                        },
                        anyChangeToBaseline: {
                          type: 'object',
                          properties: {
                            confirmation: {
                              type: 'string',
                              enum: ['Yes', 'No']
                            },
                            varianceReason: {
                              type: 'string'
                            },
                            variance: {
                              type: 'object',
                              properties: {
                                baseline: {
                                  type: 'string'
                                },
                                lastReturn: {
                                  type: 'string'
                                }
                              }
                            }
                          }
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
                        lastReturn: {
                          type: 'string',
                          title: 'Last Return (If Applicable)',
                          sourceKey: %i[return_data fundingPackages fundingStack totalCost currentAmount]
                        },
                        currentAmount: {
                          type: 'string',
                          title: '',
                          hidden: true,
                          sourceKey: %i[return_data fundingPackages fundingStack totalCost currentAmount]
                        },
                        anyChange: {
                          type: 'string',
                          enum: ['Yes', 'No']
                        },
                        variance: {
                          type: 'object',
                          properties: {
                            baseline: {
                              type: 'string'
                            },
                            lastReturn: {
                              type: 'string'
                            }
                          }
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
                        areCostsFunded: {
                          type: 'object',
                          properties: {
                            confirmation: {
                              type: 'string',
                              title: "If applicable, Are increased costs funded?",
                              enum: ['Yes', 'No', 'N/A']
                            },
                            fundingExplanation: {
                              type: 'string',
                              title: 'How are you intending to fund additional costs?'
                            },
                            description: {
                              type: 'string',
                              title: 'Desciption of how increased costs are funded'
                            }
                          }
                        }
                      }
                    },
                    fundedThroughHIF: {
                      type: 'string',
                      title: 'Totally funded through HIF?',
                      radio: true,
                      enum: %w[Yes No],
                      sourceKey: [:return_or_baseline, [:baseline_data, :costs, :infrastructure, :totallyFundedThroughHIF], [:return_data, :fundingPackages, :fundingStack, :fundedThroughHIF]],
                      readonly: true,
                    },
                    fundedThroughHIFbaseline: {
                      type: 'string',
                      title: 'Totally funded through HIF?',
                      enum: %w[Yes No],
                      sourceKey: [:return_or_baseline, [:baseline_data, :costs, :infrastructure, :totallyFundedThroughHIF], [:return_data, :fundingPackages, :fundingStack, :fundedThroughHIF]]
                    },
                    currentFundingStackDescription: {
                      type: 'string'
                    },
                    anyChange: {
                      type: 'object',
                      properties: {
                        confirmation: {
                          type: 'string',
                          title: 'Has position changed from baseline/ last return?',
                        },
                        descriptionOfChange: {
                          type: 'string',
                          title: 'Description of Change'
                        }
                      }
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
                              sourceKey: [:return_or_baseline, [:baseline_data, :costs, :infrastructure, :descriptionOfFundingStack], [:return_data, :fundingPackages, :fundingStack, :currentFundingStackDescription]]
                            },
                            anyChangeToDescription: {
                              type: 'object',
                              properties: {
                                confirmation: {
                                  type: 'string'
                                },
                                updatedFundingStack: {
                                  type: 'string'
                                }
                              }
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
                                lastReturn: {
                                  title: 'Last Return Amount',
                                  type: 'string',
                                  sourceKey: [:return_data, :fundingPackages, :fundingStack, :public, :currentAmount]
                                },
                                anyChangeToBaseline: {
                                  type: 'object',
                                  properties: {
                                    confirmation: {
                                      type: 'string',
                                      enum: ['Yes', 'No']
                                    },
                                    variance: {
                                      type: 'object',
                                      properties: {
                                        baselineVariance: {
                                          title: 'Variance Against Baseline',
                                          type: 'string',
                                          readonly: true
                                        },
                                        lastReturnVariance: {
                                          title: 'Variance Against Last Return',
                                          type: 'string',
                                          readonly: true
                                        }
                                      }
                                    }
                                  }
                                },
                                balancesSecured: {
                                  type: 'object',
                                  title: '',
                                  properties: {
                                    remainingToBeSecured: {
                                      title: 'Remaining to be Secured',
                                      type: 'string'
                                    },
                                    securedAgainstBaseline: {
                                      title: 'Secured Against Baseline',
                                      type: 'string'
                                    },
                                    securedAgainstBaselineLastReturn: {
                                      title: '',
                                      type: 'string',
                                      hidden: true,
                                      sourceKey: [:return_data, :fundingPackages, :fundingStack, :public, :balancesSecured, :securedAgainstBaseline]
                                    },
                                    increaseOnLastReturn: {
                                      title: 'Increase on Last Return',
                                      type: 'string'
                                    },
                                    increaseOnLastReturnPercent: {
                                      title: 'Increase on Last Return',
                                      type: 'string'
                                    }
                                  }
                                },
                                current: {
                                  title: 'Total - Current return',
                                  type: 'string',
                                  currency: true
                                },
                                currentAmount: {
                                  type: 'string',
                                  title: '',
                                  hidden: true,
                                  sourceKey: [:return_data, :fundingPackages, :fundingStack, :public, :currentAmount]
                                },
                                reason: {
                                  title: 'Reason for variance',
                                  type: 'string'
                                },
                                amountSecured: {
                                  title: 'Amount secured to date',
                                  type: 'string',
                                  currency: true
                                },
                                amountSecuredLastReturn: {
                                  title: '',
                                  type: 'string',
                                  sourceKey: [:return_data, :fundingPackages, :fundingStack, :public, :amountSecured]
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
                                lastReturn: {
                                  title: 'Last Return Amount',
                                  type: 'string',
                                  sourceKey: [:return_data, :fundingPackages, :fundingStack, :private, :currentAmount]
                                },
                                anyChangeToBaseline: {
                                  type: 'object',
                                  properties: {
                                    confirmation: {
                                      type: 'string',
                                      enum: ['Yes', 'No']
                                    },
                                    variance: {
                                      type: 'object',
                                      properties: {
                                        baselineVariance: {
                                          title: 'Variance Against Baseline',
                                          type: 'string',
                                          readonly: true
                                        },
                                        lastReturnVariance: {
                                          title: 'Variance Against Last Return',
                                          type: 'string',
                                          readonly: true
                                        }
                                      }
                                    }
                                  }
                                },
                                balancesSecured: {
                                  type: 'object',
                                  title: '',
                                  properties: {
                                    securedAgainstBaselineLastReturn: {
                                      title: '',
                                      type: 'string',
                                      hidden: true,
                                      sourceKey: [:return_data, :fundingPackages, :fundingStack, :private, :balancesSecured, :securedAgainstBaseline]
                                    },
                                    remainingToBeSecured: {
                                      title: 'Remaining to be Secured',
                                      type: 'string'
                                    },
                                    securedAgainstBaseline: {
                                      title: 'Secured Against Baseline',
                                      type: 'string'
                                    },
                                    increaseOnLastReturn: {
                                      title: 'Increase on Last Return',
                                      type: 'string'
                                    },
                                    increaseOnLastReturnPercent: {
                                      title: 'Increase on Last Return',
                                      type: 'string'
                                    }
                                  }
                                },
                                current: {
                                  title: 'Total - Current return',
                                  type: 'string',
                                  currency: true
                                },
                                currentAmount: {
                                  type: 'string',
                                  title: '',
                                  hidden: true,
                                  sourceKey: [:return_data, :fundingPackages, :fundingStack, :private, :currentAmount]
                                },
                                reason: {
                                  title: 'Reason for variance',
                                  type: 'string'
                                },
                                amountSecured: {
                                  title: 'Amount secured to date',
                                  type: 'string',
                                  currency: true
                                },
                                amountSecuredLastReturn: {
                                  title: '',
                                  type: 'string',
                                  sourceKey: [:return_data, :fundingPackages, :fundingStack, :private, :amountSecured]
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
      }
    end

    add_s151_tab
    add_confirmation_tab
    add_outputs_forecast_tab
    add_outputs_actuals_tab
    add_wider_scheme_tab
    add_rm_monthly_catchup_tab
    add_mr_review_tab
    add_hif_recovery_tab

    @return_template
  end

  private

  def add_outputs_forecast_tab
    return if ENV['OUTPUTS_FORECAST_TAB'].nil?
    @return_template.schema[:properties][:outputsForecast] = {
      title: 'Outputs - Forecast',
      type: 'object',
      properties: {
        summary: {
          type: 'object',
          title: 'Summary',
          properties: {
            totalUnits: {
              type: 'string',
              title: 'Total Units',
              readonly: true,
              sourceKey: %i[baseline_data outputsForecast totalUnits]
            },
            disposalStrategy: {
              type: 'string',
              title: 'Disposal Strategy/Critical Path',
              readonly: true,
              sourceKey: %i[baseline_data outputsForecast disposalStrategy]
            }
          }
        },
        housingStarts: {
          type: 'object',
          title: 'Housing Starts',
          properties: {
            baselineAmounts: {
              title: 'Baseline Amounts',
              type: 'array',
              periods: true,
              items: {
                type: 'object',
                properties: {
                  period: {
                    type: 'string',
                    title: 'Period',
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast period]
                  },
                  baselineAmounts: {
                    type: 'string',
                    title: 'Baseline Amounts',
                    currency: true,
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast target]
                  }
                }
              }
            },
            anyChanges: {
              title: 'Any changes to baseline amounts?',
              type: 'string',
              radio: true,
              enum: %w[Yes No]
            }
          },
          dependencies: {
            anyChanges: {
              oneOf: [
                {
                  properties: {
                    anyChanges: { enum: ['Yes'] },
                    currentReturnAmounts: {
                      type: 'array',
                      periods: true,
                      title: 'Current Return Amounts',
                      items: {
                        type: 'object',
                        properties: {
                          period: {
                            type: 'string',
                            title: 'Period',
                            readonly: true,
                            sourceKey: %i[baseline_data outputsForecast housingForecast period]
                          },
                          currentReturnForecast: {
                            type: 'string',
                            title: 'Current Return Forecast',
                            currency: true
                          }
                        }
                      }
                    }
                  }
                },
                {
                  properties: {
                    anyChanges: { enum: ['No'] }
                  }
                }
              ]
            }
          }
        },
        inYearHousingStarts: {
          type: "object",
          title: "In Year Housing Starts",
          properties: {
            newYear: {
              type: "object",
              title: "",
              properties: {
                setNewAmounts: {
                  type: "string",
                  title: "  ",
                  enum: ["Set this years forecasted amounts.", "This years amounts have already been set."],
                  radio: true
                }
              },
              dependencies: {
                setNewAmounts: {
                  oneOf: [
                    {
                      properties: {
                        setNewAmounts: {
                          enum: ["Set this years forecasted housing starts."]
                        },
                        newStarts: {
                          type: "object",
                          horizontal: true,
                          title: "This Years Forecasted Amounts",
                          properties: {
                            quarter1: {
                              type: "string",
                              title: "Q1 Current Year"
                            },
                            quarter2: {
                              type: "string",
                              title: "Q2 Current Year"
                            },
                            quarter3: {
                              type: "string",
                              title: "Q3 Current Year"
                            },
                            quarter4: {
                              type: "string",
                              title: "Q4 Current Year"
                            }
                          }
                        }
                      }
                    },
                    {
                      properties: {
                        setNewAmounts: {
                          enum: ["This years housing starts have already been set."]
                        }
                      }
                    }
                  ]
                }
              }
            },
            currentAmounts: {
              type: "object",
              title: "Forecasted Amounts",
              properties: {
                quarter1: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter1],
                  title: "Q1 Current Year"
                },
                quarter2: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter2],
                  title: "Q2 Current Year"
                },
                quarter3: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter3],
                  title: "Q3 Current Year"
                },
                quarter4: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter4],
                  title: "Q4 Current Year"
                }
              }
            },
            baselineAmounts: {
              type: "object",
              horizontal: true,
              title: "Baseline Amounts",
              properties: {
                quarter1:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter1],
                  title: "Q1 Current Year"
                },
                quarter2:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter2],
                  title: "Q2 Current Year"
                },
                quarter3:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter3],
                  title: "Q3 Current Year"
                },
                quarter4:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts currentAmounts quarter4],
                  title: "Q4 Current Year"
                }
              }
            },
            actualAmounts: {
              type: "object",
              horizontal: true,
              title: "Actual Amounts",
              properties: {
                liveStarts: {
                  type: "array",
                  hidden: true,
                  title: "",
                  items: {
                    type: "object",
                    title: "",
                    hidden: true,
                    properties: {
                      startsPerSite: {
                        type: "string",
                        hidden: true,
                        title: ""
                      }
                    }
                  }
                },
                quarter1:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts actualAmounts quarter1],
                  title: "Q1 Current Year"
                },
                quarter2:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts actualAmounts quarter2],
                  title: "Q2 Current Year"
                },
                quarter3:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts actualAmounts quarter3],
                  title: "Q3 Current Year"
                },
                quarter4:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingStarts actualAmounts quarter4],
                  title: "Q4 Current Year"
                }
              }
            },
            progress: {
              type: "string",
              title: "Progress",
              percentage: true,
              readonly: true
            }
          }
        },
        housingCompletions: {
          type: 'object',
          title: 'Housing Completions',
          properties: {
            baselineAmounts: {
              title: 'Baseline Amounts',
              periods: true,
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  period: {
                    type: 'string',
                    title: 'Period',
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast period]
                  },
                  baselineAmounts: {
                    type: 'string',
                    title: 'Baseline Amounts',
                    readonly: true,
                    currency: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast housingCompletions]
                  }
                }
              }
            },
            anyChanges: {
              title: 'Any changes to baseline amounts?',
              type: 'string',
              radio: true,
              enum: %w[Yes No]
            }
          },
          dependencies: {
            anyChanges: {
              oneOf: [
                {
                  properties: {
                    anyChanges: { enum: ['Yes'] },
                    currentReturnAmounts: {
                      type: 'array',
                      periods: true,
                      title: 'Current Return Amounts',
                      items: {
                        type: 'object',
                        properties: {
                          period: {
                            type: 'string',
                            title: 'Period',
                            readonly: true,
                            sourceKey: %i[baseline_data outputsForecast housingForecast period]
                          },
                          currentReturnForecast: {
                            type: 'string',
                            title: 'Current Return Forecast',
                            currency: true
                          }
                        }
                      }
                    }
                  }
                },
                {
                  properties: {
                    anyChanges: { enum: ['No'] }
                  }
                }
              ]
            }
          }
        },
        inYearHousingCompletions: {
          type: "object",
          title: "In Year Housing Completions",
          properties: {
            newYear: {
              type: "object",
              title: "",
              properties: {
                setNewAmounts: {
                  type: "string",
                  title: "  ",
                  enum: ["Set this years forecasted amounts.", "This years amounts have already been set."],
                  radio: true
                }
              },
              dependencies: {
                setNewAmounts: {
                  oneOf: [
                    {
                      properties: {
                        setNewAmounts: {
                          enum: ["Set this years forecasted housing starts."]
                        },
                        newCompletions: {
                          type: "object",
                          horizontal: true,
                          title: "This Years Forecasted Amounts",
                          properties: {
                            quarter1: {
                              type: "string",
                              title: "Q1 Current Year"
                            },
                            quarter2: {
                              type: "string",
                              title: "Q2 Current Year"
                            },
                            quarter3: {
                              type: "string",
                              title: "Q3 Current Year"
                            },
                            quarter4: {
                              type: "string",
                              title: "Q4 Current Year"
                            }
                          }
                        }
                      }
                    },
                    {
                      properties: {
                        setNewAmounts: {
                          enum: ["This years housing starts have already been set."]
                        }
                      }
                    }
                  ]
                }
              }
            },
            currentAmounts: {
              type: "object",
              title: "Forecasted Amounts",
              properties: {
                quarter1: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter1],
                  title: "Q1 Current Year"
                },
                quarter2: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter2],
                  title: "Q2 Current Year"
                },
                quarter3: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter3],
                  title: "Q3 Current Year"
                },
                quarter4: {
                  type: "string",
                  hidden: true,
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter4],
                  title: "Q4 Current Year"
                }
              }
            },
            baselineAmounts: {
              type: "object",
              horizontal: true,
              title: "Baseline Amounts",
              properties: {
                quarter1:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter1],
                  title: "Q1 Current Year"
                },
                quarter2:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter2],
                  title: "Q2 Current Year"
                },
                quarter3:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter3],
                  title: "Q3 Current Year"
                },
                quarter4:{
                  type: "string",
                  sourceKey: %i[return_data outputsForecast inYearHousingCompletions currentAmounts quarter4],
                  title: "Q4 Current Year"
                }
              }
            },
            actualAmounts: {
              type: "object",
              horizontal: true,
              title: "Actual Amounts",
              properties: {
                liveCompletions: {
                  type: "array",
                  hidden: true,
                  title: "",
                  items: {
                    type: "object",
                    title: "",
                    hidden: true,
                    properties: {
                      completionsPerSite: {
                        type: "string",
                        hidden: true,
                        title: ""
                      }
                    }
                  }
                },
                quarter1:{
                  type: "string",
                  title: "Q1 Current Year"
                },
                quarter2:{
                  type: "string",
                  title: "Q2 Current Year"
                },
                quarter3:{
                  type: "string",
                  title: "Q3 Current Year"
                },
                quarter4:{
                  type: "string",
                  title: "Q4 Current Year"
                }
              }
            },
            progress: {
              type: "string",
              title: "Progress",
              percentage: true,
              readonly: true
            }
          }
        }
      }
    }
  end

  def add_wider_scheme_tab
    return if ENV['WIDER_SCHEME_TAB'].nil?
    @return_template.schema[:properties][:widerScheme] = {
      type: "array",
      title: "Wider Scheme",
      items: {
        type: "object",
        title: "",
        properties: {
          overview: {
            type: "object",
            title: "Overview",
            properties: {
              masterplan: {
                title: "Masterplan for Scheme - FILE UPLOAD TO COME",
                type: "string",
                readonly: true
              },
              developmentPlan: {
                title: "Development Plan for Wider Scheme",
                type: "string",
                extendedText: true
              }
            }
          },
          keyLiveIssues: {
            type: "array",
            title: "Key Live Issues",
            addable: true,
            items: {
              type: "object",
              title: "Issue",
              properties: {
                description: {
                  type: "string",
                  title: "Description of Issue",
                  extendedText: true
                },
                dates: {
                  type: "object",
                  horizontal: true,
                  title: "",
                  properties: {
                    dateRaised: {
                      title: "Date raised",
                      type: "string",
                      format: "date"
                    },
                    estimatedCompletionDate: {
                      title: "Estimated completions date",
                      type: "string",
                      format: "date"
                    }
                  }
                },
                currentdetails: {
                  type: "object",
                  title: "",
                  horizontal: true,
                  properties: {
                    impact: {
                      title: "Impact",
                      type: "string",
                      enum: ["1", "2", "3", "4", "5"]
                    },
                    currentStatus: {
                      title: "Current status",
                      type: "string",
                      enum: ["Red", "Amber", "Green"]
                    },
                    currentReturnLikelihood: {
                      title: "Current return likelihood",
                      type: "string",
                      enum: ["1", "2", "3", "4", "5"]
                    }
                  }
                },
                mitigationActions: {
                  title: "Mitigation actions",
                  type: "string",
                  extendedText: true
                },
                ratingAfterMitigation: {
                  title: "Rating after mitigation",
                  type: "string",
                  enum: ["1","2","3","4","5"]
                }
              }
            }
          },
          topRisks: {
            title: "Top Risks to delivery of housing",
            type: "object",
            properties: {
              landAssembly: {
                type: "object",
                title: "Land Assembly",
                calculation: "get(formData, 'dates') ? set(formData, 'varianceAmount', weeksPassed(get(formData, 'dates', 'expectedCompletion'), get(formData, 'dates', 'currentReturnCompletionDate'))) : ''",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date",
                                format: "date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              procurementInfrastructure: {
                title: "Procurement - Infrastructure",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              planningInfrastructure: {
                title: "Planning- Infrastructure",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              deliveryInfrastructure: {
                title: "Delivery - Infrastructure",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              procurementHousing: {
                title: "Procurement- Housing",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              planningHousing: {
                title: "Planning - Housing",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              delivery: {
                title: "Delivery- Housing",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              fundingPackage: {
                title: "Funding Package",
                type: "object",
                properties: {
                  liveRisk: {
                    type: "string",
                    title: "Live Risk?",
                    enum: ["Yes", "No"],
                    radio: true
                  }
                },
                dependencies: {
                  liveRisk: {
                    oneOf: [
                      {
                        properties: {
                          liveRisk: {
                            enum: ["Yes"]
                          },
                          description: {
                            type: "string",
                            title: "Description Of Risk",
                            extendedText: true,
                            readonly: "2"
                          },
                          dates: {
                            type: "object",
                            title: "",
                            horizontal: true,
                            properties: {
                              expectedCompletion: {
                                type: "string",
                                title: "Expected Completion Date",
                                format: "date",
                                readonly: "2"
                              },
                              currentReturnCompletionDate: {
                                type: "string",
                                title: "Expected Return Completion Date"
                              }
                            }
                          },
                          varianceAmount: {
                            type: "string",
                            title: "Variance Amount (weeks)",
                            readonly: true
                          },
                          varianceReason: {
                            type: "string",
                            title: "Variance Reason",
                            extendedText: true
                          },
                          ratings: {
                            type: "object",
                            horizontal: "true",
                            title: "",
                            properties: {
                              baselineImpact: {
                                type: "string",
                                title: "Baseline Impact",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              baselineLikelihood: {
                                type: "string",
                                title: "Baseline Likelihood",
                                enum: ["1", "2", "3", "4","5"],
                                readonly: "2"
                              },
                              currentReturnLikelihood: {
                                type: "string",
                                title: "Current Return Likelihood",
                                enum: ["1", "2", "3", "4", "5"]
                              }
                            }
                          },
                          baselineMitigationMeasures: {
                            type: "string",
                            title: "Baseline Mitigation Measures",
                            extendedText: true,
                            readonly: "2"
                          },
                          anyChange: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Any Change?",
                                type: "string",
                                enum: ["Yes","No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      updatedMeasures: {
                                        title: "Updated Mitigation Measures",
                                        type: "string",
                                        extendedText: true
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          },
                          riskAfterMitigation: {
                            title: "Risk Rating after Mitigation",
                            type: "string",
                            enum: ["1", "2", "3", "4", "5"]
                          },
                          riskMet: {
                            type: "object",
                            title: " ",
                            properties: {
                              confirmation: {
                                title: "Risk Met?",
                                type: "string",
                                enum: ["Yes", "No"],
                                radio: true
                              }
                            },
                            dependencies: {
                              confirmation: {
                                oneOf: [
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["Yes"]
                                      },
                                      dateMet: {
                                        title: "Date Risk Met",
                                        type: "string",
                                        format: "date"
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      confirmation: {
                                        enum: ["No"]
                                      }
                                    }
                                  }
                                ]
                              }
                            }
                          }
                        }
                      },
                      {
                        properties: {
                          liveRisk: {
                            enum: ["No"]
                          }
                        }
                      }
                    ]
                  }
                }
              },
              additionalRisks: {
                title: "Any additional Risks?",
                description: "Click on the plus button to add additional risks.",
                type: "array",
                addable: true,
                items: {
                  type: "object",
                  title: "Risk",
                  properties: {
                    liveRisk: {
                      type: "string",
                      title: "Live Risk?",
                      enum: ["Yes", "No"]
                    },
                    description: {
                      type: "string",
                      title: "Description Of Risk",
                      extendedText: true,
                      readonly: "2"
                    },
                    expectedCompletion: {
                      type: "string",
                      title: "Expected Completion Date",
                      format: "date",
                      readonly: "2"
                    },
                    currentReturnCompletionDate: {
                      type: "string",
                      title: "Expected Return Completion Date"
                    },
                    varianceAmount: {
                      type: "string",
                      title: "Variance Amount (weeks)",
                      readonly: true
                    },
                    varianceReason: {
                      type: "string",
                      title: "Variance Reason",
                      extendedText: true
                    },
                    baselineImpact: {
                      type: "string",
                      title: "Baseline Impact",
                      enum: ["1", "2", "3", "4","5"],
                      readonly: "2"
                    },
                    baselineLikelihood: {
                      type: "string",
                      title: "Baseline Likelihood",
                      enum: ["1", "2", "3", "4","5"],
                      readonly: "2"
                    },
                    currentReturnLikelihood: {
                      type: "string",
                      title: "Current Return Likelihood",
                      enum: ["1", "2", "3", "4", "5"]
                    },
                    baselineMitigationMeasures: {
                      type: "string",
                      title: "Baseline Mitigation Measures",
                      extendedText: true,
                      readonly: "2"
                    },
                    anyChange: {
                      type: "object",
                      title: " ",
                      properties: {
                        confirmation: {
                          title: "Any Change?",
                          type: "string",
                          enum: ["Yes","No"]
                        }
                      },
                      dependencies: {
                        confirmation: {
                          oneOf: [
                            {
                              properties: {
                                confirmation: {
                                  enum: ["Yes"]
                                },
                                updatedMeasures: {
                                  title: "Updated of Mitigation Measures",
                                  type: "string",
                                  extendedText: true
                                }
                              }
                            },
                            {
                              properties: {
                                confirmation: {
                                  enum: ["No"]
                                }
                              }
                            }
                          ]
                        }
                      }
                    },
                    riskAfterMitigation: {
                      title: "Risk Rating after Mitigation",
                      type: "string",
                      enum: ["1", "2", "3", "4", "5"]
                    },
                    riskMet: {
                      type: "object",
                      title: " ",
                      properties: {
                        confirmation: {
                          title: "Risk Met?",
                          type: "string",
                          enum: ["Yes", "No"]
                        }
                      },
                      dependencies: {
                        confirmation: {
                          oneOf: [
                            {
                              properties: {
                                confirmation: {
                                  enum: ["Yes"]
                                },
                                dateMet: {
                                  title: "Date Risk Met",
                                  type: "string",
                                  format: "date"
                                }
                              }
                            },
                            {
                              properties: {
                                confirmation: {
                                  enum: ["No"]
                                }
                              }
                            }
                          ]
                        }
                      }
                    }
                  }
                }
              },
              progressLastQuarter: {
                title: "Describe progress for last quarter",
                type: "string",
                extendedText: true
              },
              actionsLastQuarter: {
                title: "Describe actions for last quarter",
                type: "string",
                extendedText: true
              },
              riskRegister: {
                title: "Please attach current risk register for scheme - FILE UPLOAD TO COME",
                type: "string",
                readonly: true
              }
            }
          }
        }
      }
    }
  end

  def add_confirmation_tab
    return if ENV['CONFIRMATION_TAB'].nil?
    @return_template.schema[:properties][:s151Confirmation] = {
      title: 's151 Confirmation',
      type: 'object',
      properties: {
        hifFunding: {
          type: 'object',
          title: 'HIF Funding and Profiles',
          required: %w[cashflowConfirmation],
          properties: {
            hifTotalFundingRequest: {
              type: 'string',
              title: 'HIF Total Funding Request',
              sourceKey: %i[baseline_data summary hifFundingAmount],
              readonly: true,
              currency: true
            },
            changesToRequest: {
              type: 'string',
              title: 'Please confirm there are no changes to the total HIF request',
              radio: true,
              s151WriteOnly: true,
              enum: ['Confirmed', 'Changes Required']
            },
            reasonForRequest: {
              type: 'string',
              title: 'Reason for Request',
              s151WriteOnly: true
            },
            requestedAmount: {
              type: 'string',
              title: 'Requested amount',
              s151WriteOnly: true,
              currency: true
            },
            varianceFromBaseline: {
              type:'string',
              title: 'Variance from Baseline',
              readonly: true,
              hidden: true,
              currency: true
            },
            varianceFromBaselinePercent: {
              type: 'string',
              title: 'Variance from Baseline',
              percentage: true,
              readonly: true,
              hidden: true
            },
            mitigationInPlace: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Mitigation in place to reduce further slippage'
            },
            hifFundingProfile: {
              title: 'Funding Profiles',
              type: 'array',
              items: {
                type: 'object',
                horizontal: true,
                properties: {
                  period: {
                    type: 'string',
                    title: 'Period',
                    readonly: true,
                    sourceKey: %i[baseline_data fundingProfiles period]
                  },
                  instalment1: {
                    type: 'string',
                    title: '1st Instalment',
                    readonly: true,
                    currency: true,
                    sourceKey: %i[baseline_data fundingProfiles instalment1]
                  },
                  instalment2: {
                    type: 'string',
                    title: '2nd Instalment',
                    readonly: true,
                    currency: true,
                    sourceKey: %i[baseline_data fundingProfiles instalment2]
                  },
                  instalment3: {
                    type: 'string',
                    title: '3rd Instalment',
                    readonly: true,
                    currency: true,
                    sourceKey: %i[baseline_data fundingProfiles instalment3]
                  },
                  instalment4: {
                    type: 'string',
                    title: '4th Instalment',
                    readonly: true,
                    currency: true,
                    sourceKey: %i[baseline_data fundingProfiles instalment4]
                  },
                  total: {
                    type: 'string',
                    title: 'Total',
                    readonly: true,
                    currency: true,
                    sourceKey: %i[baseline_data fundingProfiles total]
                  },
                  baselineVariance1: {
                    type: 'string',
                    title: '1st Instalment',
                    readonly: true,
                    currency: true,
                    hidden: true
                  },
                  baselineVariance2: {
                    type: 'string',
                    title: '2nd Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  baselineVariance3: {
                    type: 'string',
                    title: '3rd Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  baselineVariance4: {
                    type: 'string',
                    title: '4th Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  lastMovement1: {
                    type: 'string',
                    title: '1st Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  lastMovement2: {
                    type: 'string',
                    title: '2nd Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  lastMovement3: {
                    type: 'string',
                    title: '3rd Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  lastMovement4: {
                    type: 'string',
                    title: '4th Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  movementVariance1: {
                    type: 'string',
                    title: '1st Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  movementVariance2: {
                    type: 'string',
                    title: '2nd Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  movementVariance3: {
                    type: 'string',
                    title: '3rd Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  },
                  movementVariance4: {
                    type: 'string',
                    title: '4th Instalment',
                    readonly: true,
                    hidden: true,
                    currency: true
                  }
                }
              }
            },
            cashflowConfirmation: {
              title: 'Please confirm you are content with the submitted project cashflows',
              type: 'string',
              radio: true,
              s151WriteOnly: true,
              enum: %w[Yes No]
            }
          },
          dependencies: {
            changesToRequest: {
              oneOf: [
                {
                  properties: {
                    changesToRequest: { enum: ['Confirmed'] }
                  }
                },
                {
                  properties: {
                    changesToRequest: { enum: ['Changes Required'] },
                    reasonForRequest: {
                      type: 'string',
                      s151WriteOnly: true,
                      title: 'Reason for Request'
                    },
                    requestedAmount: {
                      type: 'string',
                      s151WriteOnly: true,
                      title: 'Requested amount',
                      currency: true
                    },
                    varianceFromBaseline: {
                      type:'string',
                      title: 'Variance from Baseline',
                      readonly: true,
                      hidden: true,
                      currency: true
                    },
                    varianceFromBaselinePercent: {
                      type: 'string',
                      title: 'Variance from Baseline',
                      percentage: true,
                      readonly: true,
                      hidden: true
                    },
                    mitigationInPlace: {
                      type: 'string',
                      title: 'Mitigation in place to reduce further slippage',
                      s151WriteOnly: true
                    },
                    amendmentConfirmation: {
                      title: 'An amendment has been made to the forecast profile in this MR - please confirm you are content with this amendment',
                      type: 'string',
                      s151WriteOnly: true,
                      radio: true,
                      enum: %w[Yes No]
                    },
                  }
                }
              ]
            }
          }
        },
        submission: {
          type: 'object',
          title: 'Submission',
          properties: {
            signoff: {
              title: 'Signoff',
              type: 'string'
            },
            changeToMilestones: {
              type: 'string',
              title: 'Please confirm that no changes are required to contractual milestones',
              s151WriteOnly: true,
              radio: true,
              enum: ['Confirmed', 'Changes Required']
            },
            reasonForRequestOfMilestoneChange: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Reason for Request'
            },
            requestedAmendments: {
              s151WriteOnly: true,
              type: 'string',
              title: 'Requested amendments to milestones'
            },
            mitigationInPlaceMilestone: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Mitigation in place to reduce further amendments'
            },
            hifFundingEndDate: {
              type: 'string',
              title: 'HIF Funding End Date',
              readonly: true,
              sourceKey: %i[baseline_data s151 s151FundingEndDate]
            },
            changesToEndDate: {
              type: 'string',
              title: 'Please confirm that no changes are required to Funding End Date',
              radio: true,
              s151WriteOnly: true,
              enum: ['Confirmed', 'Changes Required']
            },
            reasonForRequestOfDateChange: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Reason for Request'
            },
            requestedChangedEndDate: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Requested new end date'
            },
            varianceFromEndDateBaseline: {
              type: 'string',
              title: 'Variance from Baseline',
              readonly: true,
              hidden: true
            },
            mitigationInPlaceEndDate: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Mitigation in place to reduce further slippage'
            },
            evidenceUpload: {
              title: "Evidence of Change to End Date",
              description: "Evidence can include invoices/ contracts/ accounting system print off. Please attach here.",
              uploadFile: "multiple",
              type: "string",
              s151WriteOnly: true
            },
            projectLongstopDate: {
              type: 'string',
              title: 'Project Longstop Date',
              readonly: true,
              sourceKey: %i[baseline_data s151 s151ProjectLongstopDate]
            },
            changesToLongstopDate: {
              type: 'string',
              title: 'Please confirm that no changes are required to project completion date',
              radio: true,
              s151WriteOnly: true,
              enum: ['Confirmed', 'Changes Required']
            },
            reasonForRequestOfLongstopChange: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Reason for Request'
            },
            requestedLongstopEndDate: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Requested new end date'
            },
            varianceFromLongStopBaseline: {
              type: 'string',
              title: 'Variance from Baseline',
              readonly: true,
              hidden: true
            },
            mitigationInPlaceLongstopDate: {
              type: 'string',
              s151WriteOnly: true,
              title: 'Mitigation in place to reduce further slippage'
            },
            evidenceUploadLongstopDate: {
              title: "Evidence of Change to Project Longstop Date",
              description: "Evidence can include invoices/ contracts/ accounting system print off. Please attach here.",
              uploadFile: "multiple",
              type: "string",
              s151WriteOnly: true
            },
            recoverFunding: {
              type: 'string',
              title: 'Has any funding been recovered since last return?',
              radio: true,
              s151WriteOnly: true,
              enum: %w[Yes No]
            },
            usedOnFutureHosuing: {
              type: 'string',
              title: 'Will/Has this been used on future housing?',
              radio: true,
              s151WriteOnly: true,
              enum: %w[Yes No]
            }
          }
        }
      }
    }
  end

  def add_s151_tab
    return if ENV['S151_TAB'].nil?
    @return_template.schema[:properties][:s151] = {
      title: 's151 Return - Claim',
      type: 'object',
      properties: {
        claimSummary: {
          title: 'Summary of Claim',
          type: 'object',
          properties: {
            hifTotalFundingRequest: {
              type: 'string',
              title: 'HIF Total Funding Request',
              sourceKey: %i[baseline_data summary hifFundingAmount],
              readonly: true,
              currency: true
            },
            hifSpendToDate: {
              type: 'string',
              title: 'HIF Spend to Date',
              currency: true,
              readonly: true,
              sourceKey: %i[return_data s151 claimSummary runningClaimTotal]
            },
            AmountOfThisClaim: {
              type: 'string',
              title: 'Amount of this Claim',
              currency: true,
              s151WriteOnly: true
            },
            runningClaimTotal: {
              type: 'string',
              hidden: true
            }
          }
        },
        supportingEvidence: {
          type: 'object',
          title: 'Supporting Evidence',
          properties: {
            lastQuarterMonthSpend: {
              type: 'object',
              title: 'Last Quarter Month Spend',
              properties: {
                forecast: {
                  title: 'Forecasted Spend Last Quarter Month',
                  type: 'string',
                  sourceKey: %i[return_data s151 supportingEvidence breakdownOfNextQuarterSpend forecast],
                  currency: true,
                  readonly: true
                },
                actual: {
                  title: 'Actual Spend Last Quarter Month',
                  type: 'string',
                  s151WriteOnly: true,
                  currency: true
                },
                variance: {
                  title: '',
                  type: 'object',
                  properties: {
                    varianceAgainstForecastAmount: {
                      title: 'Variance Against Forecast',
                      type: 'string',
                      s151WriteOnly: true,
                      currency: true
                    },
                    varianceAgainstForecastPercentage: {
                      title: 'Variance Against Forecast',
                      type: 'string',
                      s151WriteOnly: true,
                      percentage: true
                    },
                    varianceReason: {
                      title: 'Reason for Variance',
                      s151WriteOnly: true,
                      type: 'string'
                    }
                  }
                }
              }
            },
            evidenceOfSpendPastQuarter: {
              title: 'Evidence of Spend for the Past Quarter.',
              type: 'string',
              s151WriteOnly: true,
              hidden: true
            },
            breakdownOfNextQuarterSpend: {
              title: 'Breakdown of Next Quarter Spend',
              type: 'object',
              properties: {
                forecast: {
                  title: 'Forecasted Spend (£)',
                  type: 'string',
                  s151WriteOnly: true,
                  currency: true
                },
                descriptionOfSpend: {
                  title: 'Description of Spend',
                  type: 'string',
                  s151WriteOnly: true,
                  extendedText: true
                },
                evidenceOfSpendNextQuarter: {
                  title: 'Evidence to Support Forecast Spend for Next Quarter',
                  type: 'string',
                  s151WriteOnly: true,
                  hidden: true
                }
              }
            }
          }
        }
      }
    }
  end

  def add_rm_monthly_catchup_tab
    return if ENV['RM_MONTHLY_CATCHUP_TAB'].nil?
    @return_template.schema[:properties][:rmMonthlyCatchup] = {
      title: "RM Monthly Catch Up",
      type: "object",
      laHidden: true,
      properties: {
        catchUp: {
          type: "array",
          description: "Click on the plus button to add notes from a new catch up.",
          title: "",
          addable: true,
          items: {
            title: "Catch Up",
            type: "object",
            properties: {
              dateOfCatchUp: {
                type: "string",
                title: "Date of Catch Up"
              },
              overallRatingForScheme: {
                type: "string",
                title: "Overall RAG Rating for Scheme",
                radio: true,
                enum: ["Red", "Amber", "Green"]
              },
              redBarriers: {
                type: "array",
                addable: true,
                title: "Barriers- Red Rating",
                description: "Click on the plus button to add a new red rated barrier.",
                items: {
                  type: "object",
                  properties: {
                    barrier: {
                      type: "string",
                      title: "Barrier",
                      enum: [
                        "Land acquisition",
                        "Site Access- Road",
                        "Site Access- Railway",
                        "Flood risk",
                        "Funding- sources/ cashflow",
                        "Planning",
                        "Land Remediation",
                        "Utilities Provision",
                        "Procurement",
                        "Other"
                      ]
                    }
                  },
                  dependencies: {
                    barrier: {
                      oneOf: [
                        {
                          properties: {
                            barrier: {
                              enum: ["Other"]
                            },
                            description: {
                              type: "string",
                              title: "Description",
                              extendedText: true
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Land acquisition"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Site Access- Road"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Site Access- Railway"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Flood risk"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Funding- sources/ cashflow"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Planning"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Land Remediation"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Utilities Provision"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Procurement"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              },
              amberBarriers: {
                type: "array",
                title: "Barriers- Amber Rating",
                description: "Click on the plus button to add a new amber rated barrier.",
                addable: true,
                items: {
                  type: "object",
                  properties: {
                    barrier: {
                      type: "string",
                      title: "Barrier",
                      enum: [
                        "Land acquisition",
                        "Site Access- Road",
                        "Site Access- Railway",
                        "Flood risk",
                        "Funding- sources/ cashflow",
                        "Planning",
                        "Land Remediation",
                        "Utilities Provision",
                        "Procurement",
                        "Other"
                      ]
                    }
                  },
                  dependencies: {
                    barrier: {
                      oneOf: [
                        {
                          properties: {
                            barrier: {
                              enum: ["Other"]
                            },
                            description: {
                              type: "string",
                              title: "Description",
                              extendedText: true
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Land acquisition"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Site Access- Road"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Site Access- Railway"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Flood risk"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Funding- sources/ cashflow"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Planning"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Land Remediation"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Utilities Provision"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        },
                        {
                          properties: {
                            barrier: {
                              enum: ["Procurement"]
                            },
                            overview: {
                              type: "string",
                              extendedText: true,
                              title: "Overview of Barrier"
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              },
              overviewOfEngagement: {
                type: "string",
                extendedText: true,
                title: "Overview of Engagement"
              },
              commentOnProgress: {
                type: "string",
                extendedText: true,
                title: "Comments on Progress"
              },
              issuesToRaise: {
                type: "string",
                extendedText: true,
                title: "Issues to Raise"
              }
            }
          }
        }
      }
    }
  end

  def add_outputs_actuals_tab
    return if ENV['OUTPUTS_ACTUALS_TAB'].nil?
    @return_template.schema[:properties][:outputsActuals] = {
      title: 'Output - Actuals',
      type: 'array',
      items: {
        type: 'object',
        title: 'Site',
        properties: {
          localAuthority: {
            type: 'string',
            title: 'Local Authority',
            readonly: true,
            sourceKey: %i[baseline_data outputsActuals siteOutputs siteLocalAuthority]
          },
          noOfUnits: {
            type: 'string',
            title: 'No. of Units',
            readonly: true,
            sourceKey: %i[baseline_data outputsActuals siteOutputs siteNumberOfUnits]
          },
          size: {
            type: 'string',
            title: 'Size (hectares)'
          },
          previousStarts: {
            type: 'string',
            title: 'Previous Starts',
            readonly: true,
            sourceKey: %i[return_data outputsActuals currentStarts]
          },
          currentStarts: {
            type: 'string',
            hidden: true
          },
          startsSinceLastReturn: {
            type: 'string',
            title: 'Starts since last return'
          },
          previousCompletions: {
            type: 'string',
            title: 'Previous Completions',
            sourceKey: %i[return_data outputsActuals currentCompletions],
            readonly: true
          },
          currentCompletions: {
            type: 'string',
            hidden: true
          },
          completionsSinceLastReturn: {
            type: 'string',
            title: 'Completions since last return'
          },
          laOwned: {
            type: 'string',
            title: 'Local Authority owned land?',
            radio: true,
            enum: %w[
              Yes
              No
            ]
          },
          pslLand: {
            type: 'string',
            radio: true,
            title: 'Public Sector Land?',
            enum: %w[
              Yes
              No
            ]
          },
          brownfieldPercent: {
            type: 'string',
            title: 'Brownfield',
            percentage: true
          },
          leaseholdPercent: {
            type: 'string',
            title: 'Leasehold',
            percentage: true
          },
          smePercent: {
            type: 'string',
            title: 'SME',
            percentage: true
          },
          mmcPercent: {
            type: 'string',
            title: 'MMC',
            percentage: true
          }
        }
      }
    }
  end

  def add_mr_review_tab
    return if ENV['MR_REVIEW_TAB'].nil?
    @return_template.schema[:properties][:reviewAndAssurance] = {
      title: "Review and Assurance",
      type: "object",
      laHidden: true,
      properties: {
        date: {
          title: "Date of most recent quarterly meeting",
          type: "string",
          format: "date"
        },
        meetingsAttended: {
          type: 'string',
          title: 'Boards/Governance meetings attended'
        },
        attendance: {
          title: 'Who was in attendance?',
          type: 'string'
        },
        infrastructureDeliveries: {
          type: "array",
          title: "",
          items: {
            type: "object",
            title: "",
            horizontal: true,
            properties: {
              infrastructureDesc: {
                type: 'string',
                hidden: true,
                sourceKey: %i[baseline_data  infrastructures description]
              },
              details: {
                type: "string",
                title: "Infrastructure Delivery",
                extendedText: true
              },
              riskRating: {
                type: "string",
                title: "Risk Rating",
                radio: true,
                enum: [
                  "High",
                  "Medium High",
                  "Medium Low",
                  "Low",
                  "Achieved"
                ]
              }
            }
          }
        },
        hifFundedFinancials: {
          type: "object",
          title: "HIF Funded Financials",
          properties: {
            summary: {
              title: "Summary",
              type: "string"
            },
            riskRating: {
              type: "string",
              title: "Risk Rating",
              radio: true,
              enum: [
                "High",
                "Medium High",
                "Medium Low",
                "Low",
                "Achieved"
              ]
            }
          }
        },
        hifWiderScheme: {
          type: "object",
          title: "Wider Scheme",
          properties: {
            summary: {
              title: "Summary",
              type: "string"
            },
            riskRating: {
              type: "string",
              title: "Risk Rating",
              radio: true,
              enum: [
                "High",
                "Medium High",
                "Medium Low",
                "Low",
                "Achieved"
              ]
            }
          }
        },
        outputForecast: {
          type: "object",
          title: "Output Forecast",
          properties: {
            summary: {
              title: "Summary",
              type: "string"
            },
            riskRating: {
              type: "string",
              title: "Risk Rating",
              radio: true,
              enum: [
                "High",
                "Medium High",
                "Medium Low",
                "Low",
                "Achieved"
              ]
            }
          }
        },
        barriers: {
          type: 'object',
          title: 'Barriers',
          properties: {
            significantIssues: {
              type: 'array',
              title: 'Significant Issues',
              addable: true,
              items: {
                type: 'object',
                properties: {
                  barrierType: {
                    title: 'Type',
                    type: 'string',
                    enum: [
                      'Land acquisition',
                      'Site Access - Road',
                      'Site Access - Railway',
                      'Flood risk',
                      'Funding - sources / cashflow',
                      'Planning',
                      'Land Remediation',
                      'Utilities Provision',
                      'Procurement',
                      'Other'
                    ]
                  },
                  commentary: {
                    title: 'Commentary',
                    type: 'string',
                    extendedText: true
                  },
                  overview: {
                    title: 'Overview',
                    type:'string',
                    extendedText: true
                  }
                },
                dependencies: {
                  barrierType: {
                    oneOf: [
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Land acquisition']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Site Access - Road']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Site Access - Railway']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Flood risk']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Funding - sources / cashflow']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Planning']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Land Remediation']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Utilities Provision']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Procurement']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Other']
                          },
                          details: {
                            title: 'Details',
                            type: 'string'
                          }
                        }
                      }
                    ]
                  }
                }
              }
            },
            liveIssues: {
              type: 'array',
              title: 'Live Issues (with mitigation)',
              addable: true,
              items: {
                type: 'object',
                properties: {
                  barrierType: {
                    title: 'Type',
                    type: 'string',
                    enum: [
                      'Land acquisition',
                      'Site Access - Road',
                      'Site Access - Railway',
                      'Flood risk',
                      'Funding - sources / cashflow',
                      'Planning',
                      'Land Remediation',
                      'Utilities Provision',
                      'Procurement',
                      'Other'
                    ]
                  },
                  commentary: {
                    title: 'Commentary',
                    type: 'string',
                    extendedText: true
                  },
                  overview: {
                    title: 'Overview',
                    type:'string',
                    extendedText: true
                  }
                },
                dependencies: {
                  barrierType: {
                    oneOf: [
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Land acquisition']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Site Access - Road']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Site Access - Railway']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Flood risk']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Funding - sources / cashflow']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Planning']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Land Remediation']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Utilities Provision']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Procurement']
                          }
                        }
                      },
                      {
                        properties: {
                          barrierType: {
                            type: 'string',
                            enum: ['Other']
                          },
                          details: {
                            title: 'Details',
                            type: 'string'
                          }
                        }
                      }
                    ]
                  }
                }
              }
            }
          }
        },
        assuranceReview: {
          type: "object",
          title: "Assurance Review",
          calculation: "set(formData, 'infrastructureDeliveryAssurance', setArrayField(get(formData,'infrastructureDeliveryCopy'), ['infrastructureDesc'], get(formData, 'infrastructureDeliveryAssurance'))); set(formData, 'infrastructureDeliveryAssurance', setArrayField(get(formData,'infrastructureDeliveryCopy'), ['reviewDetails'], get(formData, 'infrastructureDeliveryAssurance')));",
          description: "Only to be completed by the assurance team. This page will only become available when the RM review is complete.",
          properties: {
            summaryOfMeeting: {
              type: "string",
              title: "Summary Of Meeting",
              extendedText: true
            },
            overallRAGRating: {
              type: "object",
              title: "Overall RAG Rating",
              horizontal: true,
              properties: {
                rating: {
                  type: "string",
                  title: "",
                  radio: true,
                  enum: ["Red", "Amber", "Green"]
                },
                reason: {
                  type: "string",
                  title: "Reason for Rating",
                  extendedText: true
                }
              }
            },
            overallCommentary: {
              type: "string",
              title: "Overall Commentary on Performance",
              extendedText: true
            },
            riskAssessmentSpend: {
              type: "object",
              horizontal: true,
              title: "Risk Assessment - Spend",
              properties: {
                currentYear: {
                  type: "string",
                  title: "Current Year",
                  enum: ["Low", "Medium Low", "Medium High", "High"]
                },
                nextYear: {
                  type: "string",
                  title: "Next Year",
                  enum: ["Low", "Medium Low", "Medium High", "High"]
                }
              }
            },
            riskAssessmentOutputs: {
              type: "object",
              title: "Risk Assessment - Outputs",
              horizontal: true,
              properties: {
                currentYear: {
                  type: "string",
                  title: "Current Year",
                  enum: ["Low", "Medium Low", "Medium High", "High"]
                },
                nextYear: {
                  type: "string",
                  title: "Next Year",
                  enum: ["Low", "Medium Low", "Medium High", "High"]
                }
              }
            },
            raisedIssues: {
              type: "object",
              title: "Issues Raised",
              properties: {
                anyIssuesToEscalate: {
                  type: "string",
                  title: "Any issues requiring escalation?",
                  radio: true,
                  enum: ["Yes", "No"]
                }
              },
              dependencies: {
                anyIssuesToEscalate: {
                  oneOf: [
                    {
                      properties: {
                        anyIssuesToEscalate: {
                          enum: ["Yes"]
                        },
                        escalationProposals: {
                          type: "string",
                          title: "Escalation Proposals",
                          extendedText: true
                        }
                      }
                    },
                    {
                      properties: {
                        anyIssuesToEscalate: {
                          enum: ["No"]
                        }
                      }
                    }
                  ]
                }
              }
            },
            moreRegularMonitoring: {
              type: "object",
              title: "",
              properties: {
                moreMonitoringRequired: {
                  type: "string",
                  title: "More regular monitoring required?",
                  enum: ["Yes", "No"],
                  radio: true
                }
              },
              dependencies: {
                moreMonitoringRequired: {
                  oneOf: [
                    {
                      properties: {
                        moreMonitoringRequired: {
                          enum: ["Yes"]
                        },
                        requiredFrequency: {
                          type: "string",
                          title: "Required Frequency",
                          enum: [
                            "Fortnightly",
                            "Monthly",
                            "Two-Monthly",
                            "Six-Monthly",
                            "Yearly"
                          ]
                        }
                      }
                    },
                    {
                      properties: {
                        moreMonitoringRequired: {

                          enum: ["No"]
                        }
                      }
                    }
                  ]
                }
              }
            },
            commentary: {
              type: "string",
              title: "Commentary",
              extendedText: true
            }
          }
        }
      }
    }
  end

  def add_hif_recovery_tab
    return if ENV['HIF_RECOVERY_TAB'].nil?
    @return_template.schema[:properties][:hifRecovery] = {
      title: "HIF Recovery",
      type: "object",
      properties: {
        recovery: {
          title: "",
          type: "object",
          properties: {
            aimToRecoverFunding: {
              title: "Aim to recover funding?",
              radio: true,
              enum: ["Yes", "No"],
              sourceKey: %i[baseline_data recovery aimToRecover],
              readonly: true
            }
          },
          dependencies: {
            aimToRecoverFunding: {
              oneOf: [
                {
                  properties: {
                    aimToRecoverFunding: {
                      type: "string",
                      enum: ["No"]
                    }
                  }
                },
                {
                  properties: {
                    aimToRecoverFunding: {
                      type: "string",
                      enum: ["Yes"]
                    },
                    expectedAmountToRecover: {
                      type: "object",
                      title: "Expected Amount to Recover",
                      properties: {
                        baselineAmount: {
                          title: "Baseline Amount",
                          type: "string",
                          readonly: true,
                          currency: true,
                          sourceKey: %i[baseline_data recovery expectedAmount]
                        },
                        methodOfRecovery: {
                          title: "Method of Recovery",
                          type: "string",
                          readonly: true,
                          sourceKey: %i[baseline_data recovery methodOfRecovery]
                        },
                        changeToBaseline: {
                          title: "",
                          type: "object",
                          properties: {
                            confirmation: {
                              title: "Any Change?",
                              type: "string",
                              enum: ["Yes", "No"],
                              sourceKey: %i[return_data hifRecovery recovery expectedAmountToRecover changeToBaseline confirmation],
                              radio: true
                            }
                          },
                          dependencies: {
                            confirmation: {
                              oneOf: [
                                {
                                  properties: {
                                    confirmation: {
                                      type: "string",
                                      enum: ["No"]
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    confirmation: {
                                      type: "string",
                                      enum: ["Yes"]
                                    },
                                    currentReturn: {
                                      title: "Current Return",
                                      type: "string",
                                      currency: true
                                    },
                                    currentCopy: {
                                      type: 'string',
                                      hidden: true,
                                      sourceKey: %i[return_data hifRecovery recovery expectedAmountToRecover changeToBaseline currentCopy]
                                    },
                                    lastReturn: {
                                      title: "Last Return",
                                      type: "string",
                                      currency: true,
                                      sourceKey: %i[return_data hifRecovery recovery expectedAmountToRecover changeToBaseline currentCopy],
                                      readonly: true
                                    },
                                    varianceAgainstBaseline: {
                                      title: "Variance Against Baseline",
                                      type: "string",
                                      currency: true,
                                      readonly: true
                                    },
                                    varianceAgainstLastReturn: {
                                      title: "Variance Against Last Return",
                                      type: "string",
                                      currency: true,
                                      readonly: true
                                    },
                                    reasonForVariance: {
                                      title: "Reason for Variance",
                                      type: "string",
                                      extendedText: true
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        },
                        amountRecovered: {
                          title: "Amount Recovered",
                          type: "object",
                          properties: {
                            currentReturn: {
                              title: "Current Return",
                              type: "string",
                              currency: true
                            },
                            previousCumulator: {
                              type: "string",
                              readonly: true,
                              hidden: true,
                              sourceKey: %i[return_data hifRecovery recovery expectedAmountToRecover amountRecovered cumulative]
                            },
                            cumulative: {
                              title: "Cumulative Amount",
                              type: "string",
                              currency: true,
                              sourceKey: %i[return_data hifRecovery recovery expectedAmountToRecover amountRecovered cumulative],
                              readonly: true
                            },
                            remaining: {
                              title: "Remaining Amount",
                              type: "string",
                              currency: true,
                              readonly: true
                            },
                            useOfRecoveredFunding: {
                              title: "Use of Recovered Funding",
                              type: "string",
                              extendedText: true
                            },
                            planAttachment: {
                              title: "",
                              description: "Please attach the evidence here.",
                              uploadFile: "single",
                              type: "string"
                            }
                          }
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
  end
end
