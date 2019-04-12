{
  summary: {
    BIDReference: '12345',
    projectName: 'Project name',
    leadAuthority: 'Made Tech',
    projectDescription: 'Descripion of project',
    noOfHousingSites: 10,
    totalArea: 10,
    hifFundingAmount: '10000',
    descriptionOfInfrastructure: 'An infrastructure',
    descriptionOfWiderProjectDeliverables: 'Wider infrastructure'
  },
  infrastructures: [
    {
      type: 'A House',
      description: 'A house of cats',
      outlinePlanningStatus: {
        granted: true,
        grantedReference: 'The Dogs',
        targetSubmission: '2020-01-01',
        targetGranted: '2020-01-01',
        summaryOfCriticalPath: 'Summary of critical path'
      },
      fullPlanningStatus: {
        granted: false,
        grantedReference: '1234',
        targetSubmission: '2020-01-01',
        targetGranted: '2020-01-01',
        summaryOfCriticalPath: 'Summary of critical path'
      },
      s106: {
        requirement: true,
        summaryOfRequirement: 'Required'
      },
      statutoryConsents: {
        anyConsents: true,
        detailsOfConsent: 'Details of consent',
        targetDateToBeMet: '2020-01-01'
      },
      landOwnership: {
        underControlOfLA: true,
        ownershipOfLandOtherThanLA: 'Dave',
        landAcquisitionRequired: true,
        howManySitesToAcquire: 10,
        toBeAcquiredBy: 'Dave',
        targetDateToAcquire: '2020-01-01',
        summaryOfCriticalPath: 'Summary of critical path',
        procurement: {
          contractorProcured: true,
          nameOfContractor: 'Dave',
          targetDateToAquire: '2020-01-01',
          summaryOfCriticalPath: 'Summary of critical path'
        }
      },
      milestones: [
        {
          descriptionOfMilestone: 'Milestone One',
          target: '2020-01-01',
          summaryOfCriticalPath: 'Summary of critical path'
        }
      ],
      expectedInfrastructureStart: {
        targetDateOfAchievingStart: '2020-01-01'
      },
      expectedInfrastructureCompletion: {
        targetDateOfAchievingCompletion: '2020-01-01'
      },
      risksToAchievingTimescales: [
        {
          descriptionOfRisk: 'Risk one',
          impactOfRisk: 'High',
          likelihoodOfRisk: 'High',
          mitigationOfRisk: 'Do not do the thing'
        }
      ]
    }
  ],
  financial: [
    {
      period: '2020',
      instalments: [
        {
          dateOfInstalment: '2020-01-01',
          instalmentAmount: '1000',
          baselineInstalments: [
            {
              baselineInstalmentYear: '4000',
              baselineInstalmentQ1: '1000',
              baselineInstalmentQ2: '1000',
              baselineInstalmentQ3: '1000',
              baselineInstalmentQ4: '1000',
              baselineInstalmentTotal: '1000'
            }
          ]
        }
      ],
      costs: [
        {
          costOfInfrastructure: '1000',
          fundingStack: {
            totallyFundedThroughHIF: true,
            descriptionOfFundingStack: 'Stack',
            totalPublic: '2000',
            totalPrivate: '2000'
          }
        }
      ],
      baselineCashFlow: {
        summaryOfRequirement: 'data-url'
      },
      recovery: {
        aimToRecover: true,
        expectedAmountToRemove: 10,
        methodOfRecovery: 'Recovery method'
      }
    }
  ],
  s151: {
    s151FundingEndDate: '2020-01-01',
    s151ProjectLongstopDate: '2020-01-01'
  },
  outputsForecast: {
    totalUnits: 10,
    disposalStrategy: 'Disposal strategy',
    housingForecast: [
      {
        date: '2020-01-01',
        target: '2020-01-01',
        housingCompletions: '2020-01-01'
      }
    ]
  },
  outputsActuals: {
    siteOutputs: [
      siteName: 'Site name',
      siteLocalAuthority: 'Local Authority',
      siteNumberOfUnits: '123'
    ]
  }
}
