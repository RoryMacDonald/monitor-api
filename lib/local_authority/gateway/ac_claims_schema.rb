require 'json'

class LocalAuthority::Gateway::ACClaimSchemaTemplate
  def execute
    @return_template = Common::Domain::Template.new.tap do |p|
      p.schema = {
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
  end
end