class LocalAuthority::Gateway::ACReturnsSchemaTemplate
  def execute
    @return_template = Common::Domain::Template.new.tap do |p|
      p.schema = {
        title: 'AC Project',
        type: 'object',
        properties: {
          sites: {
            type: 'array',
            title: 'Sites',
            items: {
              type: 'object',
              title: 'Site',
              properties: {
                summary: {
                  type: 'object',
                  title: 'Summary',
                  properties: {
                    name: { type: 'string', title: 'Name', sourceKey: %i[baseline_data summary sitesSummary innerSummary name]},
                    ref: { type: 'string', title: 'LMT / GIS ref', sourceKey: %i[baseline_data summary sitesSummary innerSummary details ref]},
                    totalNoOfUnits: {
                      type: 'object',
                      title: 'Total number of units',
                      properties: {
                        baseline: {
                          type: 'string',
                          title: 'Baseline',
                          readonly: true,
                          sourceKey: %i[
                            baseline_data
                            summary
                            sitesSummary
                            units
                            numberOfUnitsTotal
                          ]
                        },
                        live: {
                          type: 'string',
                          title: 'Live',
                          readonly: true
                        }
                      }
                    },
                    affordableHousingUnits: {
                      type: 'object',
                      title: 'Affordable Housing Units',
                      properties: {
                        baseline: {
                          title: 'Baseline',
                          type: 'string',
                          readonly: true,
                          sourceKey: %i[
                            baseline_data
                            summary
                            sitesSummary
                            units
                            numberOfUnits
                            numberOfUnitsAffordable
                          ]
                        },
                        live: {
                          title: 'Live',
                          type: 'string',
                          readonly: true
                        }
                      }
                    },
                    planningStatus: {
                      type: 'string',
                      title: 'Planning Status',
                      readonly: true,
                      sourceKey: %i[
                            baseline_data
                            summary
                            sitesSummary
                            innerSummary
                            planningStatus
                          ]
                    }
                  }
                },
                housingOutputs: {
                  type: 'object',
                  title: 'Housing Outputs',
                  properties: {
                    baselineunits: {
                      type: 'string',
                      title: 'Units',
                      readonly: true,
                      sourceKey: %i[
                        baseline_data
                        summary
                        sitesSummary
                        units
                        numberOfUnitsTotal
                      ]
                    },
                    baselineAffordableHousingUnits: {
                      type: "string",
                      title: "Baseline Affordable Housing Units",
                      readonly: true,
                      sourceKey: %i[
                        baseline_data
                        summary
                        sitesSummary
                        units
                        numberOfUnits
                        numberOfUnitsAffordable
                      ]
                    },
                    affordableHousingUnits: {
                      type: 'string',
                      title: 'Affordable Housing Units',
                      readonly: true
                    },
                    units: {
                      type: 'object',
                      title: '',
                      properties: {
                        numberOfUnits: {
                          type: 'object',
                          horizontal: true,
                          title: 'Units and Tenures',
                          properties: {
                            numberOfUnitsMarket: {
                              type: 'string',
                              title: 'Market Sale'
                            },
                            numberOfUnitsSharedOwnership: {
                              type: 'string',
                              title: 'Shared Ownership'
                            },
                            numberOfUnitsAffordable: {
                              type: 'string',
                              title: 'Affordable/Social Rent'
                            },
                            numberOfUnitsPRS: {
                              type: 'string',
                              title: 'Private Rented'
                            },
                            numberOfUnitsOther: {
                              type: 'string',
                              title: 'Other'
                            }
                          }
                        },
                        reasonForOther: {
                          type: 'string',
                          extendedText: true,
                          title: 'Explanation of other units, if any?'
                        }
                      }
                    },
                    changesRequired: {
                      type: 'object',
                      title: '',
                      properties: {
                        changesConfirmation: {
                          type: 'string',
                          enum: [
                            'Do not change the baseline',
                            'Request change to baseline to match latest estimates'
                          ],
                          radio: true,
                          title: 'Changes to Baseline?'
                        }
                      },
                      dependencies: {
                        changesConfirmation: {
                          oneOf: [
                            {
                              properties: {
                                changesConfirmation: {
                                  enum: ['Do not change the baseline']
                                }
                              }
                            },
                            {
                              properties: {
                                changesConfirmation: {
                                  enum: ['Request change to baseline to match latest estimates']
                                },
                                reason: {
                                  type: 'string',
                                  title: 'What is the reason for the change?',
                                  extendedText: true
                                }
                              }
                            }
                          ]
                        }
                      }
                    },
                    paceOfConstruction: {
                      type: 'object',
                      title: 'Pace of Construction',
                      properties: {
                        timeBetweenStartAndCompletion: {
                          type: 'object',
                          horizontal: true,
                          title: 'Months from start of first housing unit to completion of final unit.',
                          properties: {
                            baseline: {
                              type: 'string',
                              title: 'Baseline',
                              sourceKey: %i[
                                baseline_data
                                summary
                                sitesSummary
                                hiddenSchemePace
                              ],
                              readonly: true
                            },
                            latestEstimate: {
                              type: 'string',
                              title: 'Lastest Estimate'
                            }
                          }
                        },
                        reasonForChange: {
                          type: 'string',
                          extendedText: true,
                          title: 'Reason for change/variance, and steps taken to address this.'
                        }
                      }
                    },
                    modernMethodsOfConstruction: {
                      type: 'object',
                      title: 'Modern methods of construction',
                      properties: {
                        categoryA: {
                          type: 'object',
                          title: 'Category A - Volumetric',
                          horizontal: true,
                          properties: {
                            baseline: {
                              type: 'string',
                              title: 'Baseline',
                              readonly: true,
                              percentage: true,
                              sourceKey: %i[
                                baseline_data
                                summary
                                sitesSummary
                                hiddenMmcCategory
                                catA
                              ]
                            },
                            latestEstimate: {
                              type: 'string',
                              percentage: true,
                              title: 'Lastest Estimate'
                            }
                          }
                        },
                        categoryB: {
                          type: 'object',
                          title: 'Category B - Hybrid',
                          horizontal: true,
                          properties: {
                            baseline: {
                              type: 'string',
                              title: 'Baseline',
                              readonly: true,
                              percentage: true,
                              sourceKey: %i[
                                baseline_data
                                summary
                                sitesSummary
                                hiddenMmcCategory
                                catB
                              ]
                            },
                            latestEstimate: {
                              type: 'string',
                              title: 'Lastest Estimate',
                              percentage: true
                            }
                          }
                        },
                        categoryC: {
                          type: 'object',
                          title: 'Category C - Panellised',
                          horizontal: true,
                          properties: {
                            baseline: {
                              type: 'string',
                              title: 'Baseline',
                              percentage: true,
                              readonly: true,
                              sourceKey: %i[
                                baseline_data
                                summary
                                sitesSummary
                                hiddenMmcCategory
                                catC
                              ]
                            },
                            latestEstimate: {
                              type: 'string',
                              title: 'Lastest Estimate',
                              percentage: true
                            }
                          }
                        },
                        categoryD: {
                          type: 'object',
                          title: 'Category D - Sub Assemblies and Components',
                          horizontal: true,
                          properties: {
                            baseline: {
                              type: 'string',
                              title: 'Baseline',
                              percentage: true,
                              readonly: true,
                              sourceKey: %i[
                                baseline_data
                                summary
                                sitesSummary
                                hiddenMmcCategory
                                catD
                              ]
                            },
                            latestEstimate: {
                              type: 'string',
                              title: 'Lastest Estimate',
                              percentage: true
                            }
                          }
                        },
                        categoryE: {
                          type: 'object',
                          title: 'Category E - No MMC',
                          horizontal: true,
                          properties: {
                            baseline: {
                              type: 'string',
                              title: 'Baseline',
                              percentage: true,
                              readonly: true,
                              sourceKey: %i[
                                baseline_data
                                summary
                                sitesSummary
                                hiddenMmcCategory
                                catE
                              ]
                            },
                            latestEstimate: {
                              type: 'string',
                              title: 'Lastest Estimate',
                              percentage: true
                            }
                          }
                        },
                        reasonForChange: {
                          type: 'string',
                          extendedText: true,
                          title: 'Reason for change/variance, and steps being taken to address this.'
                        }
                      }
                    }
                  }
                },
                milestonesAndProgress: {
                  type: 'object',
                  title: 'Milestones and Progress',
                  properties: {
                    commencementOfDueDiligence: {
                      type: 'object',
                      title: 'Commencement of surveys and due diligence',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      horizontal: true,
                                      type: 'object',
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            commencementOfDueDiligence
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    completionOfSurveys: {
                      title: 'Completion of surveys and due diligence',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      horizontal: true,
                                      type: 'object',
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            completionOfSurveys
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    procurementOfWorksCommencementDate: {
                      title: 'Procurement of works commencement date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              enum: ['Yes', 'No', 'N/A'],
                              radio: true
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            procurementOfWorksCommencementDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    provisionOfDetailedWorks: {
                      title: 'Provision of detailed works specification and milestones',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      horizontal: true,
                                      type: 'object',
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            provisionOfDetailedWorks
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    commencementDate: {
                      title: 'Commencement of works date (first, if multiple)',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            commencementDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    completionDate: {
                      title: 'Completion of works date (last, if multiple)',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            completionDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    outlinePlanningGrantedDate: {
                      title: 'Outline planning permission granted date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    },
                                    planningReferenceNumber: {
                                      type: 'string',
                                      title: 'Planning Reference Number'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            outlinePlanningGrantedDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    reservedMatterPermissionGrantedDate: {
                      title: 'Reserved Matter Permission Granted date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    },
                                    planningReferenceNumber: {
                                      type: 'string',
                                      title: 'Planning Reference Number'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            reservedMatterPermissionGrantedDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    marketingCommenced: {
                      title: 'Developer Partner marketing commenced (EOI or formal tender)',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            marketingCommenced
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    conditionalContractSigned: {
                      title: 'Conditional contract signed',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    },
                                    namesOfContractors: {
                                      type: 'string',
                                      title: 'Name(s) of contracted housebuilders',
                                      extendedText: true
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            conditionalContractSigned
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    unconditionalContractSigned: {
                      title: 'Unconditional contract signed',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            unconditionalContractSigned
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    startOnSiteDate: {
                      title: 'Start on site date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      horizontal: true,
                                      type: 'object',
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            startOnSiteDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    startOnFirstUnitDate: {
                      title: 'Start of first unit date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      horizontal: true,
                                      type: 'object',
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            startOnFirstUnitDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    completionOfFinalUnitData: {
                      title: 'Completion of Final Unit Date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            completionOfFinalUnitData
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    projectCompletionDate: {
                      title: 'Project Completion Date',
                      type: 'object',
                      properties: {
                        completion: {
                          type: 'object',
                          title: '',
                          properties: {
                            completed: {
                              title: 'Completed?',
                              type: 'string',
                              radio: true,
                              enum: ['Yes', 'No', 'N/A']
                            }
                          },
                          dependencies: {
                            completed: {
                              oneOf: [
                                {
                                  properties: {
                                    completed: { enum: ['Yes'] },
                                    dateOfCompletion: {
                                      type: 'string',
                                      title: 'Date completed?',
                                      format: 'date'
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: { enum: ['No'] },
                                    details: {
                                      type: 'object',
                                      horizontal: true,
                                      title: '',
                                      properties: {
                                        baselineDate: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Baseline Date',
                                          sourceKey: %i[
                                            baseline_data
                                            summary
                                            sitesSummary
                                            hiddenMilestones
                                            projectCompletionDate
                                          ],
                                          readonly: true
                                        },
                                        currentEstimatedDate: {
                                          type: 'string',
                                          title: 'Current estimated date',
                                          format: 'date'
                                        },
                                        estimatedPercentageComplete: {
                                          type: 'string',
                                          title: 'Estimated percentage complete',
                                          percentage: true
                                        }
                                      }
                                    },
                                    risk: {
                                      title: '',
                                      type: 'object',
                                      horizontal: true,
                                      properties: {
                                        riskToAchievingBaseline: {
                                          type: 'string',
                                          title: 'Risk to achieving baseline date',
                                          radio: true,
                                          enum: [
                                            'Already Achieved',
                                            'Low',
                                            'Medium Low',
                                            'Medium High',
                                            'High'
                                          ]
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reasn for risk/ variance',
                                          extendedText: true
                                        }
                                      }
                                    }
                                  }
                                },
                                {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    },
                    customMileStones: {
                      type: 'array',
                      addable: true,
                      title: 'Custom Milestones',
                      items: {
                        type: 'object',
                        properties: {
                          milestoneName: {
                            type: 'string',
                            title: 'Name of custom milestone',
                            sourceKey: %i[
                              baseline_data
                              summary
                              sitesSummary
                              hiddenMilestones
                              customMileStones
                              customTitle
                            ]
                          },
                          completion: {
                            type: 'object',
                            title: '',
                            properties: {
                              completed: {
                                title: 'Completed?',
                                type: 'string',
                                radio: true,
                                enum: ['Yes', 'No', 'N/A']
                              }
                            },
                            dependencies: {
                              completed: {
                                oneOf: [
                                  {
                                    properties: {
                                      completed: { enum: ['Yes'] },
                                      dateOfCompletion: {
                                        type: 'string',
                                        title: 'Date completed?',
                                        format: 'date'
                                      }
                                    }
                                  },
                                  {
                                    properties: {
                                      completed: { enum: ['No'] },
                                      details: {
                                        type: 'object',
                                        horizontal: true,
                                        title: '',
                                        properties: {
                                          baselineDate: {
                                            type: 'string',
                                            format: 'date',
                                            title: 'Baseline Date',
                                            sourceKey: %i[
                                              baseline_data
                                              summary
                                              sitesSummary
                                              hiddenMilestones
                                              customMileStones
                                              customDate
                                            ],
                                            readonly: true
                                          },
                                          currentEstimatedDate: {
                                            type: 'string',
                                            title: 'Current estimated date',
                                            format: 'date'
                                          },
                                          estimatedPercentageComplete: {
                                            type: 'string',
                                            title: 'Estimated percentage complete',
                                            percentage: true
                                          }
                                        }
                                      },
                                      risk: {
                                        title: '',
                                        type: 'object',
                                        horizontal: true,
                                        properties: {
                                          riskToAchievingBaseline: {
                                            type: 'string',
                                            title: 'Risk to achieving baseline date',
                                            radio: true,
                                            enum: [
                                              'Already Achieved',
                                              'Low',
                                              'Medium Low',
                                              'Medium High',
                                              'High'
                                            ]
                                          },
                                          reasonForVariance: {
                                            type: 'string',
                                            title: 'Reasn for risk/ variance',
                                            extendedText: true
                                          }
                                        }
                                      }
                                    }
                                  },
                                  {
                                  properties: {
                                    completed: {
                                      enum: ['N/A']
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason that this is not applicable'
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
                    planningStatus: {
                      type: 'string',
                      title: 'Planning Status',
                      enum: [
                        'Not in allocated for housing in Local Plan',
                        'Provisional allocation for housing',
                        'Allocated for housing in Local Plan',
                        'Outline or Reserved Matters',
                        'Consent granted'
                      ]
                    },
                    changeRequired: {
                      type: 'object',
                      title: 'Change Required?',
                      properties: {
                        changeRequiredConfirmation: {
                          type: 'string',
                          title: 'Would you like to request a change to the baseline?',
                          radio: true,
                          enum: [
                            'Do not change baseline',
                            'Request change to baseline to match latest estimates'
                          ]
                        }
                      },
                      dependencies: {
                        changeRequiredConfirmation: {
                          oneOf: [
                            {
                              properties: {
                                changeRequiredConfirmation: {
                                  enum: [
                                    'Request change to baseline to match latest estimates'
                                  ]
                                },
                                reason: {
                                  type: 'string',
                                  extendedText: true,
                                  title: 'Reason for change/variance, and steps being taken to address this'
                                }
                              }
                            },
                            {
                              properties: {
                                changeRequiredConfirmation: { enum: ['Do not change baseline'] }
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
        }
      }
    end

    add_grant_expenditure_tab
    add_s151_grant_approval
    add_housing_outputs
    add_s151_submission
    add_review_and_assurance_tab

    @return_template
  end

  private

  def add_grant_expenditure_tab
    @return_template.schema[:properties][:grantExpenditure] = {
      title: 'Grant Expenditure Profile',
      type: 'object',
      properties: {
        baseline: {
          type: 'array',
          title: 'Baseline',
          quarterly: true,
          items: {
            type: 'object',
            title: '',
            properties: {
              year: {
                type: 'string',
                title: 'Year',
                readonly: true,
                sourceKey: %i[
                  baseline_data
                  financials
                  expenditure
                  year
                ]
              },
              Q1Amount: {
                type: 'string',
                title: 'First Quarter',
                currency: true,
                readonly: true,
                sourceKey: %i[
                  baseline_data
                  financials
                  expenditure
                  Q1Amount
                ]
              },
              Q2Amount: {
                type: 'string',
                title: 'Second Quarter',
                currency: true,
                readonly: true,
                sourceKey:  %i[
                  baseline_data
                  financials
                  expenditure
                  Q2Amount
                ]
              },
              Q3Amount: {
                type: 'string',
                title: 'Third Quarter',
                currency: true,
                readonly: true,
                sourceKey:  %i[
                  baseline_data
                  financials
                  expenditure
                  Q3Amount
                ]
              },
              Q4Amount: {
                type: 'string',
                title: 'Fourth Quarter',
                currency: true,
                readonly: true,
                sourceKey:  %i[
                  baseline_data
                  financials
                  expenditure
                  Q4Amount
                ]
              },
              total: {
                type: 'string',
                title: 'Total',
                currency: true,
                readonly: true
              }
            }
          }
        },
        claimedToDate: {
          type: 'array',
          title: 'Achieved to date',
          quarterly: true,
          items: {
            type: 'object',
            title: '',
            properties: {
              year: {
                type: 'string',
                title: 'Year',
                laReadOnly: true,
                sourceKey: %i[
                  baseline_data
                  financials
                  expenditure
                  year
                ]
              },
              Q1Amount: {
                type: 'string',
                laReadOnly: true,
                title: 'First Quarter',
                currency: true
              },
              Q2Amount: {
                type: 'string',
                title: 'Second Quarter',
                laReadOnly: true,
                currency: true
              },
              Q3Amount: {
                type: 'string',
                title: 'Third Quarter',
                laReadOnly: true,
                currency: true
              },
              Q4Amount: {
                type: 'string',
                title: 'Fourth Quarter',
                laReadOnly: true,
                currency: true
              },
              total: {
                type: 'string',
                title: 'Total',
                currency: true,
                readonly: true
              }
            }
          }
        },
        remainingEstimate: {
          type: 'array',
          title: 'Remaining Estimate',
          quarterly: true,
          items: {
            type: 'object',
            title: '',
            properties: {
              year: {
                type: 'string',
                title: 'Year',
                sourceKey: %i[
                  baseline_data
                  financials
                  expenditure
                  year
                ]
              },
              Q1Amount: {
                type: 'string',
                title: 'First Quarter',
                currency: true
              },
              Q2Amount: {
                type: 'string',
                title: 'Second Quarter',
                currency: true
              },
              Q3Amount: {
                type: 'string',
                title: 'Third Quarter',
                currency: true
              },
              Q4Amount: {
                type: 'string',
                title: 'Fourth Quarter',
                currency: true
              },
              total: {
                type: 'string',
                title: 'Total',
                currency: true,
                readonly: true
              }
            }
          }
        },
        riskRating: {
          type: 'array',
          title: 'Risk Rating on Remaining Estimates',
          quarterly: true,
          items: {
            type: 'object',
            title: '',
            properties: {
              year: {
                type: 'string',
                title: 'Year',
                sourceKey: %i[
                  baseline_data
                  financials
                  expenditure
                  year
                ]
              },
              Q1Rating: {
                type: 'string',
                title: 'First Quarter',
                enum: [
                  'Already Achieved',
                  'Low',
                  'Medium Low',
                  'Medium High',
                  'High'
                ]
              },
              Q2Rating: {
                type: 'string',
                title: 'Second Quarter',
                enum: [
                  'Already Achieved',
                  'Low',
                  'Medium Low',
                  'Medium High',
                  'High'
                ]
              },
              Q3Rating: {
                type: 'string',
                title: 'Third Quarter',
                enum: [
                  'Already Achieved',
                  'Low',
                  'Medium Low',
                  'Medium High',
                  'High'
                ]
              },
              Q4Rating: {
                type: 'string',
                title: 'Fourth Quarter',
                enum: [
                  'Already Achieved',
                  'Low',
                  'Medium Low',
                  'Medium High',
                  'High'
                ]
              },
              total: {
                type: 'string',
                title: 'Total',
                enum: [
                  'Already Achieved',
                  'Low',
                  'Medium Low',
                  'Medium High',
                  'High'
                ],
                readonly: true
              }
            }
          }
        },
        changesRequired: {
          type: 'string',
          radio: true,
          title: 'Changes Required?',
          enum: [
            'Do not change the baseline',
            'Request change to baseline to match latest estimates'
          ]
        }
      },
      dependencies: {
        changesRequired: {
          oneOf: [
            {
              properties: {
                changesRequired: { enum: ['Do not change the baseline'] }
              }
            },
            {
              properties: {
                changesRequired: {
                  enum: [
                    'Request change to baseline to match latest estimates'
                  ]
                },
                reasonForChange: {
                  type: 'string',
                  title: 'Reason for change/variance, and steps being taken to address this',
                  extendedText: true
                },
                evidenceUpload: {
                  type: "string",
                  title: "Please upload any evidence demonstrating the need to change the baseline, for example responses to tenders.",
                  uploadFile: "multiple"
                }
              }
            }
          ]
        }
      }
    }
  end

  def add_s151_grant_approval
    @return_template.schema[:properties][:s151GrantClaimApproval] = {
      title: 'S151 Officer Grant Claim Approval',
      type: 'object',
      properties: {
        claimSummary: {
          title: 'Summary of Claim',
          type: 'object',
          properties: {
            TotalFundingRequest: {
              type: 'string',
              title: 'Total Funding Request',
              s151WriteOnly: true,
              currency: true
            },
            SpendToDate: {
              type: 'string',
              hidden: true,
              title: 'Claimed to Date',
              s151WriteOnly: true,
              currency: true
            },
            AmountOfThisClaim: {
              type: 'string',
              title: 'Amount of this Claim',
              s151WriteOnly: true,
              currency: true
            },
            conditionsToGrantDrawdown: {
              type: "string",
              title: "Conditions precedent to draw down of grant",
              uploadFile: "multiple",
              description: "If you have conditions to meet before you can draw down grant, please email any evidence for meeting these to your Homes England projects lead, or attach the documents below."
            }
          }
        },
        supportingEvidence: {
          type: 'object',
          title: 'Supporting Evidence',
          properties: {
            evidenceOfSpendPastQuarter: {
              title: 'Evidence of Spend for the Past Quarter.',
              type: 'string',
              s151WriteOnly: true,
              hidden: true
            },
            breakdownOfNextQuarterSpend: {
              title: 'Evidence of Next Quarter Spend',
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
                }
              }
            }
          }
        }
      }
    }
  end

  def add_housing_outputs
    @return_template.schema[:properties][:housingCompletions] = {
      title: 'Housing Completions',
      type: 'array',
      items: {
        type: 'object',
        title: 'Site',
        properties: {
          details: {
            type: 'object',
            title: 'Housing Completions',
            properties: {
              siteName: {
                type: 'string',
                title: 'Site Name',
                readonly: true,
                sourceKey: %i[baseline_data summary sitesSummary innerSummary name]

              },
              achievedToDate: {
                type: 'array',
                title: 'Achieved to date',
                quarterly: true,
                items: {
                  type: 'object',
                  title: '',
                  properties: {
                    year: {
                      type: 'string',
                      title: 'Year',
                      laReadOnly: true
                    },
                    Q1Amount: {
                      type: 'string',
                      laReadOnly: true,
                      title: 'First Quarter'
                    },
                    Q2Amount: {
                      type: 'string',
                      title: 'Second Quarter',
                      laReadOnly: true
                    },
                    Q3Amount: {
                      type: 'string',
                      title: 'Third Quarter',
                      laReadOnly: true,
                      currency: true
                    },
                    Q4Amount: {
                      type: 'string',
                      title: 'Fourth Quarter',
                      laReadOnly: true
                    },
                    total: {
                      type: 'string',
                      title: 'Total',
                      readonly: true
                    }
                  }
                }
              },
              remainingEstimate: {
                type: 'array',
                title: 'Remaining Estimate',
                quarterly: true,
                items: {
                  type: 'object',
                  title: '',
                  properties: {
                    year: {
                      type: 'string',
                      title: 'Year'
                    },
                    Q1Amount: {
                      type: 'string',
                      title: 'First Quarter'
                    },
                    Q2Amount: {
                      type: 'string',
                      title: 'Second Quarter'
                    },
                    Q3Amount: {
                      type: 'string',
                      title: 'Third Quarter'
                    },
                    Q4Amount: {
                      type: 'string',
                      title: 'Fourth Quarter'
                    },
                    total: {
                      type: 'string',
                      title: 'Total',
                      readonly: true
                    },
                    riskRating: {
                      type: 'string',
                      title: 'Total',
                      enum: [
                        'Already Achieved',
                        'Low',
                        'Medium Low',
                        'Medium High',
                        'High'
                      ]
                    }
                  }
                }
              },
              changesRequired: {
                type: 'object',
                title: 'Changes Required?',
                properties: {
                  changesConfirmation: {
                    type: 'string',
                    radio: true,
                    enum: [
                      'Do not change the baseline',
                      'Request change to baseline to match latest estimates'
                    ]
                  }
                },
                dependencies: {
                  changesConfirmation: {
                    oneOf: [
                      {
                        properties: {
                          changesConfirmation: { enum: ['Do not change the baseline'] }
                        }
                      },
                      {
                        properties: {
                          changesConfirmation: {
                            enum: [
                              'Request change to baseline to match latest estimates'
                            ]
                          },
                          reasonForChange: {
                            type: 'string',
                            title: 'Reason for change/variance, and steps being taken to address this',
                            extendedText: true
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

  def add_s151_submission
    @return_template.schema[:properties][:s151submission] = {
      title: 'S151 Officer Submission Sign-Off',
      type: 'object',
      properties: {
        submission: {
          type: 'object',
          title: '',
          properties: {
            confirmation: {
              type: 'object',
              title: 'Please confirm you are content with the submission, including:',
              properties: {
                estimatedGrantProfiles: {
                  type: 'string',
                  title: 'Estimated grant draw down profiles, including any changes requested to these',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                },
                milestoneDateEstimates: {
                  type: 'string',
                  title: 'Milestone date estimates, including any changes requested to these',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                },
                milestoneDatesAchieved: {
                  type: 'string',
                  title: 'Milestone dates achieved, including any evidence submitted to validate these',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                },
                housingOutputsEstimates: {
                  type: 'string',
                  title: 'Housing output profile estimates, including any changes requested to these',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                },
                housingClaimedAsAchieved: {
                  type: 'string',
                  title: 'Housing outputs claimed as achieved, including any evidence submitted to validate these',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                },
                receiptEstimates: {
                  type: 'string',
                  title: 'Receipt (income) estimates and actual income, including any evidence submitted to validate these',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                },
                noOtherGrantFundin: {
                  type: 'string',
                  title: 'That no other Grant Funding Agreement conditions have been breached.',
                  enum: ['Yes', 'No'],
                  s151WriteOnly: true,
                  radio: true
                }
              }
            }
          }
        }
      }
    }
  end

  def add_review_and_assurance_tab
    @return_template.schema[:properties][:reviewAndAssurance] = {
      title: 'Review and Assurance',
      type: 'object',
      laHidden: true,
      properties: {
        date: {
          title: 'Date of most recent meeting',
          type: 'string',
          format: 'date'
        },
        dateRisk: {
          title: 'Date risk ratings last updated',
          type: 'string',
          format: 'date'
        },
        infrastructureDelivery: {
          type: 'object',
          title: '',
          horizontal: true,
          properties: {
            details: {
              type: 'string',
              title: 'Infrastructure Delivery',
              extendedText: true
            },
            riskRating: {
              type: 'string',
              title: 'Risk Rating',
              radio: true,
              enum: [
                'High',
                'Medium High',
                'Medium Low',
                'Low',
                'Achieved'
              ]
            }
          }
        },
        planningAndProcurement: {
          type: 'object',
          title: '',
          horizontal: true,
          properties: {
            details: {
              type: 'string',
              title: 'Planning and Procurement',
              extendedText: true
            },
            riskRating: {
              type: 'string',
              title: 'Risk Rating',
              radio: true,
              enum: [
                'High',
                'Medium High',
                'Medium Low',
                'Low',
                'Contractual'
              ]
            }
          }
        },
        expenditure: {
          type: 'object',
          title: '',
          horizontal: true,
          properties: {
            details: {
              type: 'string',
              title: 'Expenditure',
              extendedText: true
            },
            riskRating: {
              type: 'string',
              title: 'Risk Rating',
              radio: true,
              enum: [
                'High',
                'Medium High',
                'Medium Low',
                'Low',
                'Contractual'
              ]
            }
          }
        },
        deliverablesObjectivesAndOutputs: {
          type: 'object',
          title: '',
          horizontal: true,
          properties: {
            details: {
              type: 'string',
              title: 'Deliverables, Objectives and Outputs',
              extendedText: true
            },
            riskRating: {
              type: 'string',
              title: 'Risk Rating',
              radio: true,
              enum: [
                'High',
                'Medium High',
                'Medium Low',
                'Low',
                'Contractual'
              ]
            }
          }
        },
        overallSummary: {
          type: 'object',
          title: '',
          horizontal: true,
          properties: {
            details: {
              type: 'string',
              title: 'Overall Summary',
              extendedText: true
            },
            riskRating: {
              type: 'string',
              title: 'Overall risk rating',
              radio: true,
              enum: [
                'High',
                'Medium High',
                'Medium Low',
                'Low',
                'Contractual'
              ]
            }
          }
        },
        heAuthorisation: {
          type: 'object',
          title: 'Homes England Authorisation',
          properties: {
            heAuthoriser: {
              type: 'string',
              title: 'Authorised by:',
              laReadOnly: true
            }
          }
        }
      }
    }
  end
end
