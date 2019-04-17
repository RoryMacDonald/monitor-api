# frozen_string_literal: true

class UI::UseCase::ConvertUIHIFProject
  def execute(project_data:)
    @project = project_data
    @converted_project = {}

    convert_project_summary
    convert_infrastructures
    convert_funding_profiles
    convert_costs
    convert_baseline_cash_flow
    convert_s151
    convert_outputs_forecast
    convert_outputs_actuals
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
      pcsNumber: @project[:summary][:pcsNumber],
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
      converted_infrastructure = {}

      unless infrastructure[:summary].nil?
        converted_infrastructure[:type] = infrastructure[:summary][:type]
        converted_infrastructure[:description] = infrastructure[:summary][:description]
        converted_infrastructure[:housingSitesBenefitting] = infrastructure[:summary][:housingSitesBenefitting]

        unless infrastructure[:summary][:expectedInfrastructureStart].nil?
          unless infrastructure[:summary][:expectedInfrastructureStart][:procurementDateValidator].nil?
            unless infrastructure[:summary][:expectedInfrastructureStart][:procurementDateValidator][:grantedDateValidator].nil?
              converted_infrastructure[:expectedInfrastructureStart] = {
                targetDateOfAchievingStart: infrastructure[:summary][:expectedInfrastructureStart][:procurementDateValidator][:grantedDateValidator][:targetDateOfAchievingStart]
              }
            end
          end
        end

        unless infrastructure[:summary][:expectedInfrastructureCompletion].nil?
          converted_infrastructure[:expectedInfrastructureCompletion] = {
            targetDateOfAchievingCompletion: infrastructure[:summary][:expectedInfrastructureCompletion][:targetDateOfAchievingCompletion]
          }
        end
      end

      unless infrastructure[:planningStatus].nil?
        unless infrastructure[:planningStatus][:planningStatus].nil?
          unless infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus].nil?
            converted_infrastructure[:outlinePlanningStatus] = {
              granted: infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus][:granted],
              reference: infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus][:reference],
              targetSubmission: infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus][:targetSubmission],
              targetGranted: infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus][:targetGranted],
              summaryOfCriticalPath: infrastructure[:planningStatus][:planningStatus][:outlinePlanningStatus][:summaryOfCriticalPath]
            }
          end

          unless infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus].nil?
            converted_infrastructure[:fullPlanningStatus] = {
              granted: infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus][:granted],
              grantedReference: infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus][:grantedReference],
              grantedDate: infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus][:grantedDate],
              targetSubmission: infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus][:targetSubmission],
              targetGranted: infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus][:targetGranted],
              summaryOfCriticalPath: infrastructure[:planningStatus][:planningStatus][:fullPlanningStatus][:summaryOfCriticalPath]
            }
          end
        end

        unless infrastructure[:planningStatus][:s106].nil?
          converted_infrastructure[:s106] = {
            requirement: infrastructure[:planningStatus][:s106][:requirement],
            summaryOfRequirement: infrastructure[:planningStatus][:s106][:summaryOfRequirement]
          }
        end

        unless infrastructure[:planningStatus][:statutoryConsents].nil?
          converted_infrastructure[:statutoryConsents] = {
            anyConsents: infrastructure[:planningStatus][:statutoryConsents][:anyConsents]
          }

          unless infrastructure[:planningStatus][:statutoryConsents][:consents].nil?
            converted_infrastructure[:statutoryConsents][:consents] = infrastructure[:planningStatus][:statutoryConsents][:consents].map do |consent|
              {
                detailsOfConsent: consent[:detailsOfConsent],
                targetDateToBeMet: consent[:targetDateToBeMet]
              }
            end
          end
        end
      end

      unless infrastructure[:landOwnership].nil?
        converted_infrastructure[:landOwnership] = {}
        unless infrastructure[:landOwnership][:landControl].nil?
          converted_infrastructure[:landOwnership][:underControlOfLA] = infrastructure[:landOwnership][:landControl][:underControlOfLA]
          converted_infrastructure[:landOwnership][:ownershipOfLandOtherThanLA] = infrastructure[:landOwnership][:landControl][:ownershipOfLandOtherThanLA]
        end

        unless infrastructure[:landOwnership][:acquisitionRequired].nil?
          converted_infrastructure[:landOwnership][:isLandAcquisitionRequired] = infrastructure[:landOwnership][:acquisitionRequired][:isLandAcquisitionRequired]
          converted_infrastructure[:landOwnership][:criticalPath] = infrastructure[:landOwnership][:acquisitionRequired][:criticalPath]
          converted_infrastructure[:landOwnership][:dateToAcquire] = infrastructure[:landOwnership][:acquisitionRequired][:dateToAcquire]
          converted_infrastructure[:landOwnership][:acquiredBy] = infrastructure[:landOwnership][:acquisitionRequired][:acquiredBy]
          converted_infrastructure[:landOwnership][:sitesToAcquire] = infrastructure[:landOwnership][:acquisitionRequired][:sitesToAcquire]
        end
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
  end

  def convert_funding_profiles
    return if @project[:fundingProfiles].nil?
    return if @project[:fundingProfiles][:profilesHolder].nil?
    @converted_project[:lastFundingPeriod] = @project[:fundingProfiles][:profilesHolder][:lastPeriod]

    return if @project[:fundingProfiles][:profilesHolder][:profilesValidator].nil?
    return if @project[:fundingProfiles][:profilesHolder][:profilesValidator][:profiles].nil?

    @converted_project[:fundingProfiles] = []

    @converted_project[:fundingProfiles] = @project[:fundingProfiles][:profilesHolder][:profilesValidator][:profiles].map do |profile|
      next if profile.nil?
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
          baselineCashflows: cost[:infrastructure][:baselineCashflows]
        }
        unless cost[:infrastructure][:fundedThroughHif].nil?
          converted_cost[:infrastructure][:totallyFundedThroughHIF]  = cost[:infrastructure][:fundedThroughHif][:totallyFundedThroughHIF]
          converted_cost[:infrastructure][:descriptionOfFundingStack] = cost[:infrastructure][:fundedThroughHif][:descriptionOfFundingStack]
          converted_cost[:infrastructure][:totalPublic] = cost[:infrastructure][:fundedThroughHif][:totalPublic]
          converted_cost[:infrastructure][:totalPrivate] = cost[:infrastructure][:fundedThroughHif][:totalPrivate]
        end
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

    @converted_project[:s151] = {}

    unless @project[:s151][:s151FundingEndDateValidator].nil?
      @converted_project[:s151][:s151FundingEndDate] = @project[:s151][:s151FundingEndDateValidator][:s151FundingEndDate]
    end

    unless @project[:s151][:s151ProjectLongstopDateValidator].nil?
      @converted_project[:s151][:s151ProjectLongstopDate] = @project[:s151][:s151ProjectLongstopDateValidator][:s151ProjectLongstopDate]
      @converted_project[:s151][:s151OutputsLastPeriod] = @project[:s151][:s151ProjectLongstopDateValidator][:lastPeriod]
    end
  end

  def convert_outputs_forecast
    return if @project[:outputs].nil?
    return if @project[:outputs][0].nil?
    return if @project[:outputs][0][:outputsForecast].nil?

    @converted_project[:outputsForecast] = {
      totalUnits: @project[:outputs][0][:outputsForecast][:totalUnits],
      disposalStrategy: @project[:outputs][0][:outputsForecast][:disposalStrategy]
    }

    @converted_project[:outputsForecast].compact!


    return if @project[:outputs][0][:outputsForecast][:housingForecast].nil?
    @converted_project[:outputsForecast][:lastPeriod] = @project[:outputs][0][:outputsForecast][:housingForecast][:lastPeriod]

    return if @project[:outputs][0][:outputsForecast][:housingForecast][:forecast].nil?

    @converted_project[:outputsForecast][:housingForecast] = @project[:outputs][0][:outputsForecast][:housingForecast][:forecast].map do |forecast|
      {
        period: forecast[:period],
        target: forecast[:target],
        housingCompletions: forecast[:housingCompletions]
      }
    end
  end

  def convert_outputs_actuals
    return if @project[:outputs].nil?
    return if @project[:outputs][0].nil?
    return if @project[:outputs][0][:outputsActuals].nil?

    @converted_project[:outputsActuals] = {}

    return if @project[:outputs][0][:outputsActuals][:siteOutputs].nil?

    @converted_project[:outputsActuals] = {
      siteOutputs: @project[:outputs][0][:outputsActuals][:siteOutputs].map do |output|
        {
          siteName: output[:siteName],
          siteLocalAuthority: output[:siteLocalAuthority],
          siteNumberOfUnits: output[:siteNumberOfUnits]
        }
      end
    }
  end

  def convert_recovery
    return if @project[:recovery].nil?

    @converted_project[:recovery] = @project[:recovery]
  end

  def convert_rm_baseline
    return if @project[:rmBaseline].nil?

    @converted_project[:rmBaseline] = @project[:rmBaseline]
  end
end
