# frozen_string_literal: true

class UI::UseCase::ConvertCoreHIFProject
  def execute(project_data:)
    @project = project_data
    @converted_project = {}

    convert_project_summary
    convert_infrastructures
    convert_funding_profiles
    convert_costs
    convert_baseline_cash_flow
    convert_s151
    convert_outputs
    convert_recovery
    convert_rm_baseline

    @converted_project
  end

  private

  def convert_project_summary
    return if @project[:summary].nil?

    @converted_project[:summary] = {
      projectManager: @project[:summary][:projectManager],
      sponsor: @project[:summary][:sponsor],
      BIDReference: @project[:summary][:BIDReference],
      projectName: @project[:summary][:projectName],
      leadAuthority: @project[:summary][:leadAuthority],
      jointBidAuthorityAreas: @project[:summary][:jointBidAuthorityAreas],
      projectDescription: @project[:summary][:projectDescription],
      greenOrBrownField: @project[:summary][:greenOrBrownField],
      noOfHousingSites: @project[:summary][:noOfHousingSites],
      polygonsForHousingSite: @project[:summary][:polygonsForHousingSite],
      totalArea: @project[:summary][:totalArea],
      hifFundingAmount: @project[:summary][:hifFundingAmount],
      sitePlans: @project[:summary][:sitePlans],
      descriptionOfInfrastructure: @project[:summary][:descriptionOfInfrastructure],
      descriptionOfWiderProjectDeliverables: @project[:summary][:descriptionOfWiderProjectDeliverables]
    }

    @converted_project[:summary].compact!
  end

  def convert_infrastructures
    return @converted_project[:infrastructures] = [{}] if @project[:infrastructures].nil?
    @converted_project[:infrastructures] = @project[:infrastructures].map do |infrastructure|
      convert_infrastructure(infrastructure)
    end
  end

  def convert_infrastructure(infrastructure)
    return {} if infrastructure.empty?

    converted_infrastructure = {}

    converted_infrastructure[:summary] = {
      type: infrastructure[:type],
      description: infrastructure[:description],
      housingSitesBenefitting: infrastructure[:housingSitesBenefitting]
    }

    unless infrastructure[:expectedInfrastructureStart].nil?
      converted_infrastructure[:summary][:expectedInfrastructureStart] = {
        targetDateOfAchievingStart: infrastructure[:expectedInfrastructureStart][:targetDateOfAchievingStart]
      }
    end

    unless infrastructure[:expectedInfrastructureCompletion].nil?
      converted_infrastructure[:summary][:expectedInfrastructureCompletion] = {
        targetDateOfAchievingCompletion: infrastructure[:expectedInfrastructureCompletion][:targetDateOfAchievingCompletion]
      }
    end

    converted_infrastructure[:planningStatus] = {
      planningStatus: {
      }
    }

    unless infrastructure[:outlinePlanningStatus].nil?
      converted_infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus] = {
        granted: infrastructure[:outlinePlanningStatus][:granted],
        reference: infrastructure[:outlinePlanningStatus][:reference],
        targetSubmission: infrastructure[:outlinePlanningStatus][:targetSubmission],
        targetGranted: infrastructure[:outlinePlanningStatus][:targetGranted],
        summaryOfCriticalPath: infrastructure[:outlinePlanningStatus][:summaryOfCriticalPath]
      }
    end

    unless infrastructure[:fullPlanningStatus].nil?
      converted_infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus] = {
        granted: infrastructure[:fullPlanningStatus][:granted],
        grantedReference: infrastructure[:fullPlanningStatus][:grantedReference],
        targetSubmission: infrastructure[:fullPlanningStatus][:targetSubmission],
        targetGranted: infrastructure[:fullPlanningStatus][:targetGranted],
        summaryOfCriticalPath: infrastructure[:fullPlanningStatus][:summaryOfCriticalPath]
      }
    end

    unless infrastructure[:s106].nil?
      converted_infrastructure[:planningStatus][:s106] = {
        requirement: infrastructure[:s106][:requirement],
        summaryOfRequirement: infrastructure[:s106][:summaryOfRequirement]
      }
    end

    unless infrastructure[:statutoryConsents].nil?
      
      converted_infrastructure[:planningStatus][:statutoryConsents] = {
        anyConsents: infrastructure[:statutoryConsents][:anyConsents]
      }
      
      unless infrastructure[:statutoryConsents][:consents].nil?
        converted_infrastructure[:planningStatus][:statutoryConsents][:consents] = infrastructure[:statutoryConsents][:consents].map do |consent|
          {
            detailsOfConsent: consent[:detailsOfConsent],
            targetDateToBeMet: consent[:targetDateToBeMet]
          }
        end
      end

    end

    unless infrastructure[:landOwnership].nil?
      converted_infrastructure[:landOwnership] = {
        landControl: {
          underControlOfLA: infrastructure[:landOwnership][:underControlOfLA],
          ownershipOfLandOtherThanLA: infrastructure[:landOwnership][:ownershipOfLandOtherThanLA]
        },
        acquisitionRequired: {
          isLandAcquisitionRequired: infrastructure[:landOwnership][:isLandAcquisitionRequired],
          criticalPath: infrastructure[:landOwnership][:criticalPath],
          dateToAcquire: infrastructure[:landOwnership][:dateToAcquire],
          acquiredBy: infrastructure[:landOwnership][:acquiredBy],
          sitesToAcquire: infrastructure[:landOwnership][:sitesToAcquire]
        }
      }
    end

    unless infrastructure[:procurement].nil?
      converted_infrastructure[:procurement] = {
        contractorProcured: infrastructure[:procurement][:contractorProcured],
        nameOfContractor: infrastructure[:procurement][:nameOfContractor],
        targetDate: infrastructure[:procurement][:targetDate],
        summaryOfCriticalPath: infrastructure[:procurement][:summaryOfCriticalPath]
      }
    end

    unless infrastructure[:milestones].nil?
      converted_infrastructure[:milestones] = infrastructure[:milestones].map do |milestone|
        {
          descriptionOfMilestone: milestone[:descriptionOfMilestone],
          target: milestone[:target],
          summaryOfCriticalPath: milestone[:summaryOfCriticalPath]
        }
      end
    end

    unless infrastructure[:risksToAchievingTimescales].nil?
      converted_infrastructure[:risksToAchievingTimescales] = infrastructure[:risksToAchievingTimescales].map do |risk|
        {
          descriptionOfRisk: risk[:descriptionOfRisk],
          impactOfRisk: risk[:impactOfRisk],
          likelihoodOfRisk: risk[:likelihoodOfRisk],
          mitigationOfRisk: risk[:mitigationOfRisk]
        }
      end
    end

    converted_infrastructure.compact
  end

  def convert_funding_profiles
    return if @project[:fundingProfiles].nil?

    @converted_project[:fundingProfiles] = {}

    @converted_project[:fundingProfiles][:profiles] = @project[:fundingProfiles].map do |profile|
      {
        period: profile[:period],
        instalment1: profile[:instalment1],
        instalment2: profile[:instalment2],
        instalment3: profile[:instalment3],
        instalment4: profile[:instalment4],
        total: profile[:total]
      }.compact
    end
  end

  def convert_costs
    return if @project[:costs].nil?

    @converted_project[:costs] = []

    @converted_project[:costs] = @project[:costs].map do |cost|
      converted_cost = {}

      unless cost[:infrastructure].nil?
        converted_cost[:infrastructure] = {
          HIFAmount: cost[:infrastructure][:HIFAmount],
          totalCostOfInfrastructure: cost[:infrastructure][:totalCostOfInfrastructure],
          baselineCashflows: cost[:infrastructure][:baselineCashflows],
          fundedThroughHif: {
            totallyFundedThroughHIF: cost[:infrastructure][:totallyFundedThroughHIF],
            descriptionOfFundingStack: cost[:infrastructure][:descriptionOfFundingStack],
            totalPublic: cost[:infrastructure][:totalPublic],
            totalPrivate: cost[:infrastructure][:totalPrivate]
          }
        }
      end

      converted_cost
    end
  end

  def convert_baseline_cash_flow
    return if @project[:baselineCashFlow].nil?

    @converted_project[:baselineCashFlow] = {
      summaryOfRequirement: @project[:baselineCashFlow][:summaryOfRequirement]
    }
  end

  def convert_s151
    return if @project[:s151].nil?

    @converted_project[:s151] = {
      s151FundingEndDate: @project[:s151][:s151FundingEndDate],
      s151ProjectLongstopDate: @project[:s151][:s151ProjectLongstopDate]
    }
  end

  def convert_outputs
    @converted_project[:outputs] = [
      {
        outputsForecast: outputs_forecast,
        outputsActuals: outputs_actuals
      }
    ]
  end

  def convert_recovery
    return if @project[:recovery].nil?

    @converted_project[:recovery] = @project[:recovery]
  end

  def outputs_forecast
    return {} if @project[:outputsForecast].nil?

    converted_outputs_forecast = {
      totalUnits: @project[:outputsForecast][:totalUnits],
      disposalStrategy: @project[:outputsForecast][:disposalStrategy],
      housingForecast: {}
    }

    converted_outputs_forecast.compact!

    return {} if @project[:outputsForecast][:housingForecast].nil?

    converted_outputs_forecast[:housingForecast][:forecast] = @project[:outputsForecast][:housingForecast].map do |forecast|
      {
        period: forecast[:period],
        target: forecast[:target],
        housingCompletions: forecast[:housingCompletions]
      }
    end
    converted_outputs_forecast
  end

  def outputs_actuals
    return {} if @project[:outputsActuals].nil?

    return {} if @project[:outputsActuals][:siteOutputs].nil?

    converted_outputs_actuals = {
      siteOutputs: @project[:outputsActuals][:siteOutputs].map do |output|
        {
          siteName: output[:siteName],
          siteLocalAuthority: output[:siteLocalAuthority],
          siteNumberOfUnits: output[:siteNumberOfUnits]
        }
      end
    }

    converted_outputs_actuals
  end

  def convert_rm_baseline
    return if @project[:rmBaseline].nil?

    @converted_project[:rmBaseline] = @project[:rmBaseline]
  end
end
