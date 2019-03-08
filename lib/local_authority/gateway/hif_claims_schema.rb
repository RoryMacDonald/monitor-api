require 'json'

class LocalAuthority::Gateway::HIFClaimSchemaTemplate
  def execute
    @return_template = Common::Domain::Template.new.tap do |p|
      p.schema = {
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
                sourceKey: %i[claim_data claimSummary runningClaimTotal]
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
                    sourceKey: %i[claim_data supportingEvidence breakdownOfNextQuarterSpend forecast],
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
  end
end
