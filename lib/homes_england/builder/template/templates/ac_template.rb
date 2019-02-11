# frozen_string_literal: true

class HomesEngland::Builder::Template::Templates::ACTemplate
  def create
    ac_template = Common::Domain::Template.new
    ac_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'AC Project',
      type: 'object',
      properties: {
        summary: ac_summary,
        conditions: ac_conditions,
        financials: ac_financials,
        milestones: ac_milestones,
        outputs: ac_outputs
      }
    }
    ac_template
  end

  private

  def ac_summary
    {
      type: "object",
      title: "Project Summary",
      properties: {
        localAuthority: {
          type: "string",
          title: "Local Authority"
        },
        projectName: {
          type: "string",
          title: "Project Name"
        },
        projectRef: {
          type: "string",
          title: "Project reference"
        },
        projectDescription: {
          type: "string",
          title: "Project Description",
          extendedText: true
        },
        sitesSummary: {
          type: "array",
          addable: true,
          title: "Site(s)",
          items: {
            type: "object",
            properties: {
              hiddenMilestones: {
                type: "object",
                title: "",
                properties: {
                  commencementOfDueDiligence: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  completionOfSurveys: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  procurementOfWorksCommencementDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  provisionOfDetailedWorks: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  commencementDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  completionDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  outlinePlanningGrantedDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  reservedMatterPermissionGrantedDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  marketingCommenced: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  conditionalContractSigned: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  unconditionalContractSigned: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  startOnSiteDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  startOnFirstUnitDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  completionOfFinalUnitData: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  projectCompletionDate: {
                    type: "string",
                    title: "",
                    hidden: true
                  },
                  customMileStones: {
                    type: "array",
                    title: "",
                    items: {
                      type: "object",
                      title: "",
                      properties: {
                        customTitle: {
                          type: "string",
                          hidden: true,
                          title: "Milestone"
                        },
                        customDate: {
                          type: "string",
                          title: "Date",
                          hidden: true,
                          format: "date"
                        }
                      }
                    }
                  }
                }
              },
              mmcCategory: {
                title: "MMC Category",
                type: "object",
                properties: {
                  catA: {
                    type: "string",
                    title: "Category A - Volumetric",
                    percentage: true
                  },
                  catB: {
                    type: "string",
                    title: "Category B - Hybrid",
                    percentage: true
                  },
                  catC: {
                    type: "string",
                    title: "Category C - Panellised",
                    percentage: true
                  },
                  catD: {
                    type: "string",
                    title: "Category D -  Sub-Assemblies and Components",
                    percentage: true
                  },
                  catE: {
                    type: "string",
                    title: "Category E - Non-OSM/MMC Construction",
                    percentage: true
                  }
                }
              },
              innerSummary: {
                type: "object",
                title: "",
                properties: {
                  name: {
                    type: "string",
                    title: "Parcel/Sub Site name"
                  },
                  details: {
                    type: "object",
                    horizontal: true,
                    properties: {
                      ref: {
                        type: "string",
                        title: "LMT / GIS ref"
                      },
                      size: {
                        type: "string",
                        title: "Size (Ha)"
                      }
                    }
                  },
                  planningStatus: {
                    type: "string",
                    title: "Planning status",
                    enum: ["Not in allocated for housing in Local Plan", "Provisional allocation for housing", "Allocated for housing in Local Plan", "Outline or Reserved Matters consent granted"]
                  },
                  contacts: {
                    type: "object",
                    horizontal: true,
                    properties: {
                      laContact: {
                        type: "string",
                        title: "Key local authority contact email",
                        format: "email"
                      },
                      heContact: {
                        type: "string",
                        title: "Key Homes England contact email",
                        format: "email"
                      }
                    }
                  }
                }
              },
              hiddenMmcCategory: {
                title: "MMC Category",
                type: "object",
                properties: {
                  catA: {
                    type: "string",
                    hidden: true,
                    title: "Category A - Volumetric",
                    percentage: true
                  },
                  catB: {
                    type: "string",
                    hidden: true,
                    title: "Category B - Hybrid",
                    percentage: true
                  },
                  catC: {
                    type: "string",
                    hidden: true,
                    title: "Category C - Panellised",
                    percentage: true
                  },
                  catD: {
                    type: "string",
                    hidden: true,
                    title: "Category D -  Sub-Assemblies and Components",
                    percentage: true
                  },
                  catE: {
                    type: "string",
                    hidden: true,
                    title: "Category E - Non-OSM/MMC Construction",
                    percentage: true
                  }
                }
              },
              hiddenSchemePace: {
                type: "string",
                hidden: true,
                title: "Scheme Pace (units pm)",
                currencyMaximum: "99999"
              },
              units: {
                type: "object",
                calculation: "set(formData, 'numberOfUnitsTotal', get(formData, 'numberOfUnits') ? parseMoney(get(formData, 'numberOfUnits', 'numberOfUnitsMarket')) + parseMoney(get(formData, 'numberOfUnits', 'numberOfUnitsSharedOwnership')) + parseMoney(get(formData, 'numberOfUnits', 'numberOfUnitsAffordable')) + parseMoney(get(formData, 'numberOfUnits', 'numberOfUnitsPRS')) + parseMoney(get(formData, 'numberOfUnits', 'numberOfUnitsOther')): 0);",
                title: "",
                properties: {
                  numberOfUnits: {
                    type: "object",
                    title: "Number of:",
                    horizontal: true,
                    properties: {
                      numberOfUnitsMarket: {
                        type: "string",
                        title: "Market sale"
                      },
                      numberOfUnitsSharedOwnership: {
                        type: "string",
                        title: "Shared ownership"
                      },
                      numberOfUnitsAffordable: {
                        type: "string",
                        title: "Affordable/social rent"
                      },
                      numberOfUnitsPRS: {
                        type: "string",
                        title: "Private Rented"
                      },
                      numberOfUnitsOther: {
                        type: "string",
                        title: "Other"
                      }
                    }
                  },
                  numberOfUnitsTotal: {
                    type: "string",
                    title: "Total number of units",
                    readonly: true
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  def ac_conditions
    {
      type: "object",
      title: "Conditions",
      properties: {
        predrawdownConditions: {
          type: "object",
          title: "Pre-Drawdown Conditions",
          properties: {
            conditions: {
              title: "",
              type: "array",
              numbered: true,
              addable: true,
              items: {
                type: "object",
                properties: {
                  conditionName: {
                    type: "string",
                    title: "Condition Name"
                  },
                  conditionExplanation: {
                    type: "string",
                    title: "Condition explanation"
                  }
                }
              }
            }
          }
        },
        fundingItems: {
          type: "object",
          title: "Funding Items",
          properties: {
            fundItems: {
              title: "",
              type: "array",
              addable: true,
              items: {
                type: "object",
                properties: {
                  itemToFund: {
                    title: "",
                    type: "object",
                    horizontal: true,
                    properties: {
                      fundingItem: {
                        type: "string",
                        title: "Funding item",
                        extendedText: true
                      },
                      estimatedFunding: {
                        type: "string",
                        title: "Estimated funding",
                        currency: "true",
                        currencyMaximum: "99999999"
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

  def ac_financials
    {
      type: "object",
      title: "Financials",
      properties: {
        expenditure: {
          type: "array",
          quarterly: true,
          addable: true,
          title: "Funding Drawdown",
          items: {
            type: "object",
            properties: {
              year: {
                type: "string",
                title: "Year",
                enum: ["2018/19",  "2019/20", "2020/21"]
              },
              Q1Amount: {
                type: "string",
                title: "First Quarter",
                currency: true
              },
              Q2Amount: {
                type: "string",
                title: "Second Quarter",
                currency: true
              },
              Q3Amount: {
                type: "string",
                title: "Third Quarter",
                currency: true
              },
              Q4Amount: {
                type: "string",
                title: "Fourth Quarter",
                currency: true
              }
            }
          }
        },
        receipts: {
          type: "object",
          title: "Receipts",
          calculation: "set(formData, 'projectValue', accumulateMoney(get(formData, 'expectedDisposalReceipt'), 'amount'));",
          properties: {
            detailsOnPaymentStructure: {
              type: "string",
              title: "Details on payment structure"
            },
            expectedDisposalReceipt: {
              type: "array",
              addable: true,
              quarterly: true,
              title: "",
              items: {
                type: "object",
                properties: {
                  site: {
                    type: "string",
                    title: "Site Name"
                  },
                  amount: {
                    type: "string",
                    title: "Projected (clean site) value",
                    currency: true
                  }
                }
              }
            },
            projectValue: {
              type: "string",
              title: "Total projected (clean site) value",
              currency: true,
              currencyMaximum: "99999999",
              readonly: true
            },
            clawback: {
              type: "string",
              title: "Clawback",
              percentage: true,
              currencyMaximum: "9999"
            }
          }
        }
      }
    }
  end

  def ac_milestones
    {
      type: "object",
      title: "Milestones",
      properties: {
        surveysAndDueDiligence: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            commencementOfDueDiligence: {
              type: "string",
              format: "date",
              title: "Commencement of surveys and due diligence"
            },
            completionOfSurveys: {
              type: "string",
              format: "date",
              title: "Completion of surveys and due diligence"
            }
          }
        },
        procurementProvision: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            procurementOfWorksCommencementDate: {
              type: "string",
              format: "date",
              title: "Procurement of works commencement date"
            },
            provisionOfDetailedWorks: {
              type: "string",
              format: "date",
              title: "Provision of detailed works specification and milestones"
            }
          }
        },
        worksDate: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            commencementDate: {
              type: "string",
              format: "date",
              title: "Commencement of works date (first, if multiple)"
            },
            completionDate: {
              type: "string",
              format: "date",
              title: "Completion of works date (last, if multiple)"
            }
          }
        },
        outlinePlanning: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            outlinePlanningGrantedDate: {
              type: "string",
              format: "date",
              title: "Outline planning permission granted date"
            },
            reservedMatterPermissionGrantedDate: {
              type: "string",
              format: "date",
              title: "Reserved Matter Permission Granted date"
            }
          }
        },
        marketingCommenced: {
          type: "string",
          format: "date",
          title: "Developer Partner marketing commenced (EOI or formal tender)"
        },
        contractSigned: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            conditionalContractSigned: {
              type: "string",
              format: "date",
              title: "Conditional contract signed"
            },
            unconditionalContractSigned: {
              type: "string",
              format: "date",
              title: "Unconditional contract signed"
            }
          }
        },
        workDates: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            startOnSiteDate: {
              type: "string",
              format: "date",
              title: "Start on site date"
            },
            startOnFirstUnitDate: {
              type: "string",
              format: "date",
              title: "Start of first unit date"
            }
          }
        },
        completionDates: {
          type: "object",
          title: "",
          horizontal: true,
          properties: {
            completionOfFinalUnitData: {
              type: "string",
              title: "Completion of Final Unit Date",
              format: "date"
            },
            projectCompletionDate: {
              type: "string",
              title: "Project Completion Date",
              format: "date"
            }
          }
        },
        customMileStones: {
          type: "array",
          addable: true,
          title: "Custom Milestones",
          items: {
            type: "object",
            properties: {
              customTitle: {
                type: "string",
                title: "Milestone"
              },
              customDate: {
                type: "string",
                title: "Date",
                format: "date"
              }
            }
          }
        }
      }
    }
  end

  def ac_outputs
   {
      type: "object",
      title: "Outputs",
      properties: {
        keyProgrammeObjectives: {
          type: "object",
          title: "Key Programme Objectives",
          horizontal: true,
          properties: {
            localMarketPace: {
              type: "string",
              title: "Local Market Pace (units pm)",
              currencyMaximum:"99999"
            },
            schemePace: {
              type: "string",
              title: "Scheme Pace (units pm)",
              currencyMaximum: "99999"
            }
          }
        },
        mmcCategory: {
          title: "MMC Category",
          type: "object",
          properties: {
            catA: {
              type: "string",
              title: "Category A - Volumetric",
              percentage: true
            },
            catB: {
              type: "string",
              title: "Category B - Hybrid",
              percentage: true
            },
            catC: {
              type: "string",
              title: "Category C - Panellised",
              percentage: true
            },
            catD: {
              type: "string",
              title: "Category D -  Sub-Assemblies and Components",
              percentage: true
            },
            catE: {
              type: "string",
              title: "Category E - Non-OSM/MMC Construction",
              percentage: true
            }
          }
        }
      }
    }
  end
end
