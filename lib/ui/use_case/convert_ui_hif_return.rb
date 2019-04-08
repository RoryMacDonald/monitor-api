# frozen_string_literal: true
class UI::UseCase::ConvertUIHIFReturn
  def execute(return_data:)
    @return = return_data
    @converted_return = {}

    convert_infrastructures
    convert_funding_packages
    convert_funding_profiles
    convert_outputs_forecast
    convert_outputs_actuals
    convert_wider_scheme
    convert_s151
    convert_s151_confirmation
    convert_rm_monthly_catchup
    convert_mr_review_tab
    convert_hif_recovery_tab

    @converted_return
  end

  private

  def convert_infrastructures
    return if @return[:infrastructures].nil?

    @converted_return[:infrastructures] = @return[:infrastructures].map do |infrastructure|
      new_infrastructure = {}
      new_infrastructure[:summary] = infrastructure[:summary]
      new_infrastructure[:planning] = convert_planning(infrastructure[:planning]) unless infrastructure[:planning].nil?
      new_infrastructure[:landOwnership] = convert_land_ownership(infrastructure[:landOwnership]) unless infrastructure[:landOwnership].nil?
      new_infrastructure[:procurement] = convert_procurement(infrastructure[:procurement]) unless infrastructure[:procurement].nil?
      new_infrastructure[:milestones] = convert_milestones(infrastructure[:milestones]) unless infrastructure[:milestones].nil?
      new_infrastructure[:risks] = convert_risks(infrastructure[:risks]) unless infrastructure[:risks].nil?
      new_infrastructure[:progress] = convert_progress(infrastructure[:progress]) unless infrastructure[:progress].nil?
      new_infrastructure
    end
  end

  def convert_planning(planning)
    new_planning = {}

    unless planning[:outlinePlanning].nil?
      new_planning[:outlinePlanning] = {
        baselineOutlinePlanningPermissionGranted: planning[:outlinePlanning][:baselineOutlinePlanningPermissionGranted],
        baselineSummaryOfCriticalPath: planning[:outlinePlanning][:baselineSummaryOfCriticalPath],
        planningSubmitted: planning[:outlinePlanning][:planningSubmitted],
        planningGranted: planning[:outlinePlanning][:planningGranted],
        reference: planning[:outlinePlanning][:reference]
      }
    end

    unless planning[:planningNotGranted].nil?
      new_planning[:planningNotGranted] = {
        fieldOne: planning[:planningNotGranted][:fieldOne]
      }
    end

    unless planning[:fullPlanning].nil?
      new_planning[:fullPlanning] = {
        fullPlanningPermissionGranted: planning[:fullPlanning][:fullPlanningPermissionGranted],
        fullPlanningPermissionSummaryOfCriticalPath: planning[:fullPlanning][:fullPlanningPermissionSummaryOfCriticalPath],
        submitted: planning[:fullPlanning][:submitted],
        granted: planning[:fullPlanning][:granted],
        reference: planning[:fullPlanning][:reference]

      }
    end

    if planning[:section106].nil?
      new_planning[:section106] = {}
    else
      new_planning[:section106] = {
        s106Requirement: planning[:section106][:s106Requirement],
        s106SummaryOfRequirement: planning[:section106][:s106SummaryOfRequirement]
      }
    end

    unless planning[:statutoryConsents].nil?
      new_planning[:section106][:statutoryConsents] =  {
        anyStatutoryConsents: planning[:statutoryConsents][:anyStatutoryConsents]
      }

      unless planning[:statutoryConsents][:statutoryConsents].nil?
        new_planning[:section106][:statutoryConsents][:statutoryConsents] = planning[:statutoryConsents][:statutoryConsents].map do |consent|
          next if consent.nil?
          new_consent = {}

          new_consent = {
          detailsOfConsent: consent[:detailsOfConsent]
          }

          unless consent[:statusOfConsent].nil?
            new_consent[:baselineCompletion] = consent[:statusOfConsent][:baseline]
            new_consent[:statusAgainstLastReturn] = consent[:statusOfConsent][:status]
            new_consent[:percentComplete] = consent[:statusOfConsent][:percentComplete]
            new_consent[:completionDate] = consent[:statusOfConsent][:completedDate]
            new_consent[:currentReturn] = consent[:statusOfConsent][:current]
            new_consent[:previousReturn] = consent[:statusOfConsent][:previousReturn]
            new_consent[:varianceAgainstBaseline] = consent[:statusOfConsent][:varianceAgainstBaseline]
            new_consent[:varianceAgainstLastReturn] = consent[:statusOfConsent][:varianceAgainstLastReturn]
            new_consent[:varianceReason] = consent[:statusOfConsent][:reason]
          end
          new_consent
        end
      end
    end

    new_planning
  end

  def convert_land_ownership(land_ownership)
    new_land_ownership = {
      laDoesNotControlSite: {}
    }

    unless land_ownership[:landControl].nil?
      new_land_ownership[:laHasControlOfSite] = land_ownership[:landControl][:laHasControlOfSite]

      unless land_ownership[:landControl][:laDoesNotControlSite].nil?
        new_land_ownership[:laDoesNotControlSite][:whoOwnsSite] = land_ownership[:landControl][:laDoesNotControlSite][:whoOwnsSite]
      end
    end

    unless land_ownership[:acquisitionRequired].nil?
      new_land_ownership[:laDoesNotControlSite][:landAcquisitionRequired] = land_ownership[:acquisitionRequired][:landAcquisitionRequired]
      new_land_ownership[:laDoesNotControlSite][:howManySitesToAquire] = land_ownership[:acquisitionRequired][:howManySitesToAquire]
      new_land_ownership[:laDoesNotControlSite][:toBeAquiredBy] = land_ownership[:acquisitionRequired][:toBeAquiredBy]
      new_land_ownership[:laDoesNotControlSite][:summaryOfAcquisitionRequired] = land_ownership[:acquisitionRequired][:summaryOfAcquisitionRequired]
      new_land_ownership[:laDoesNotControlSite][:allLandAssemblyAchieved] = land_ownership[:acquisitionRequired][:allLandAssemblyAchieved]
    end

    new_land_ownership
  end

  def convert_procurement(procurement)
    new_procurement = {
      contractorProcured: procurement[:contractorProcured],
      nameOfContractor: procurement[:nameOfContractor],
      summaryOfCriticalPath: procurement[:summaryOfCriticalPath],
    }

    unless procurement[:procurementStatusAgainstLastReturn].nil?
      new_procurement[:procurementBaselineCompletion] = procurement[:procurementStatusAgainstLastReturn][:baseline]
      new_procurement[:procurementVarianceAgainstLastReturn] = procurement[:procurementStatusAgainstLastReturn][:procurementVarianceAgainstLastReturn]
      new_procurement[:procurementVarianceAgainstBaseline] = procurement[:procurementStatusAgainstLastReturn][:procurementVarianceAgainstBaseline]
      new_procurement[:percentComplete] = procurement[:procurementStatusAgainstLastReturn][:percentComplete]
      new_procurement[:procurementCompletedDate] = procurement[:procurementStatusAgainstLastReturn][:completedDate]
      new_procurement[:procurementCompletedNameOfContractor] = procurement[:procurementStatusAgainstLastReturn][:onCompletedNameOfContractor]

      new_procurement[:procurementStatusAgainstLastReturn] = {
        statusAgainstLastReturn: procurement[:procurementStatusAgainstLastReturn][:status],
        currentReturn: procurement[:procurementStatusAgainstLastReturn][:current],
        reasonForVariance: procurement[:procurementStatusAgainstLastReturn][:reason],
        previousReturn: procurement[:procurementStatusAgainstLastReturn][:previousReturn]
      }
    end

    new_procurement
  end

  def convert_milestones(milestones)
    new_milestones = {}

    unless milestones[:keyMilestones].nil?
      new_milestones[:keyMilestones] = milestones[:keyMilestones].map do |milestone|
        {
          description: milestone[:description],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneLastReturnDate: milestone[:milestoneLastReturnDate],
          milestoneSummaryOfCriticalPath: milestone[:milestoneSummaryOfCriticalPath],
          milestoneVarianceAgainstLastReturn: milestone[:milestoneVarianceAgainstLastReturn],
          milestoneVarianceAgainstBaseline: milestone[:milestoneVarianceAgainstBaseline],
          statusAgainstLastReturn: milestone[:statusAgainstLastReturn],
          currentReturn: milestone[:currentReturn],
          reasonForVariance: milestone[:reasonForVariance],
          milestonePercentCompleted: milestone[:milestonePercentCompleted],
          milestoneCompletedDate: milestone[:milestoneCompletedDate]
        }
      end
    end

    unless milestones[:additionalMilestones].nil?
      new_milestones[:additionalMilestones] = milestones[:additionalMilestones].map do |milestone|
        {
          description: milestone[:description],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneSummaryOfCriticalPath: milestone[:milestoneSummaryOfCriticalPath]
        }
      end
    end

    unless milestones[:cumulativeadditionalMilestones].nil?
      new_milestones[:cumulativeadditionalMilestones] = milestones[:cumulativeadditionalMilestones].map do |milestone|
        {
          description: milestone[:description],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneSummaryOfCriticalPath: milestone[:milestoneSummaryOfCriticalPath],
          currentReturn: milestone[:currentReturn],
          milestonePercentCompleted: milestone[:milestonePercentCompleted],
          milestoneCompletedDate: milestone[:milestoneCompletedDate],
          statusAgainstLastReturn: milestone[:statusAgainstLastReturn]
        }
      end
    end

    unless milestones[:previousMilestones].nil?
      new_milestones[:previousMilestones] = milestones[:previousMilestones].map do |milestone|
        {
          description: milestone[:description],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneSummaryOfCriticalPath: milestone[:milestoneSummaryOfCriticalPath],
          milestoneLastReturnDate: milestone[:milestoneLastReturnDate],
          milestoneVarianceAgainstLastReturn: milestone[:milestoneVarianceAgainstLastReturn],
          milestoneVarianceAgainstBaseline: milestone[:milestoneVarianceAgainstBaseline],
          statusAgainstLastReturn: milestone[:statusAgainstLastReturn],
          currentReturn: milestone[:currentReturn],
          reasonForVariance: milestone[:reasonForVariance],
          milestonePercentCompleted: milestone[:milestonePercentCompleted],
          milestoneCompletedDate: milestone[:milestoneCompletedDate]
        }
      end
    end
    unless milestones[:startAndCompletionMilestones].nil?
      new_milestones[:expectedInfrastructureStartOnSite] = milestones[:startAndCompletionMilestones][:expectedInfrastructureStartOnSite]
      new_milestones[:expectedCompletionDateOfInfra] = milestones[:startAndCompletionMilestones][:expectedCompletionDateOfInfra]
    end

    new_milestones
  end

  def convert_risks(risks)
    new_risks = {}

    unless risks[:baselineRisks].nil?
      new_risks[:baselineRisks] = risks[:baselineRisks].map do |risk|
        new_risk = {}
        new_risk[:riskBaselineRisk] = risk[:riskBaselineRisk]
        new_risk[:riskBaselineImpact] = risk[:riskBaselineImpact]
        new_risk[:riskBaselineLikelihood] = risk[:riskBaselineLikelihood]
        new_risk[:riskCurrentReturnLikelihood] = risk[:riskCurrentReturnLikelihood]
        new_risk[:riskBaselineMitigationsInPlace] = risk[:riskBaselineMitigationsInPlace]
        new_risk[:riskAnyChange] = risk[:riskAnyChange]
        new_risk[:riskCurrentReturnMitigationsInPlace] = risk[:riskCurrentReturnMitigationsInPlace]
        new_risk[:riskMetDate] = risk[:riskMet]
        new_risk[:riskCompletionDate] = risk[:riskCompletionDate]
        new_risk
      end
    end

    unless risks[:additionalRisks].nil?
      new_risks[:additionalRisks] = risks[:additionalRisks].map do |risk|
        {
          description: risk[:description],
          impact: risk[:impact],
          likelihood: risk[:likelihood],
          mitigations: risk[:mitigations]
        }
      end
    end

    unless risks[:cumulativeadditionalRisks].nil?
      new_risks[:cumulativeadditionalRisks] = risks[:cumulativeadditionalRisks].map do |risk|
        {
          description: risk[:description],
          impact: risk[:impact],
          likelihood: risk[:likelihood],
          mitigations: risk[:mitigations]
        }
      end
    end

    unless risks[:previousRisks].nil?
      new_risks[:previousRisks] = risks[:previousRisks].map do |risk|
        {
          riskBaselineRisk: risk[:description],
          riskBaselineImpact: risk[:impact],
          riskBaselineLikelihood: risk[:likelihood],
          riskCurrentReturnLikelihood: risk[:riskCurrentReturnLikelihood],
          riskBaselineMitigationsInPlace: risk[:mitigations],
          riskAnyChange: risk[:riskAnyChange],
          riskCurrentReturnMitigationsInPlace: risk[:riskCurrentReturnMitigationsInPlace],
          riskMetDate: risk[:riskMetDate]
        }
      end
    end

    new_risks
  end

  def convert_progress(progress)
    new_progress = {
      describeQuarterProgress: progress[:describeQuarterProgress]
    }

    unless progress[:progressAgainstActions].nil?
      new_progress[:progressAgainstActions] = progress[:progressAgainstActions].map do |action|
        {
          description: action[:description],
          met: action[:met],
          progress: action[:progress]
        }
      end
    end

    unless progress[:actionsForNextQuarter].nil?
      new_progress[:actionsForNextQuarter] = progress[:actionsForNextQuarter].map do |action|
        {
          description: action[:description]
        }
      end
    end

    unless progress[:carriedForward].nil?
      new_progress[:carriedForward] = progress[:carriedForward].map do |action|
        {
          description: action[:description]
        }
      end
    end

    new_progress
  end

  def convert_funding_profiles
    return if @return[:fundingProfiles].nil?
    @converted_return[:fundingProfiles] = {}
    @converted_return[:fundingProfiles][:totalHIFGrant] = @return[:fundingProfiles][:totalHIFGrant]

    unless @return[:fundingProfiles][:fundingRequest].nil?
      unless @return[:fundingProfiles][:fundingRequest][:forecast].nil?
        @converted_return[:fundingProfiles][:fundingRequest] = @return[:fundingProfiles][:fundingRequest][:forecast].map do |request|
          next if request.nil?

          new_request = { period: request[:period] }

          next new_request if request.nil?
          new_request[:forecast] = {
            instalment1: request[:instalment1],
            instalment2: request[:instalment2],
            instalment3: request[:instalment3],
            instalment4: request[:instalment4],
            total: request.dig(:totalHolder, :total)
          }
          new_request
        end
      end
    end


    unless @return[:fundingProfiles][:currentFunding].nil?
      unless @return[:fundingProfiles][:currentFunding][:forecast].nil?
        @converted_return[:fundingProfiles][:currentFunding] = {}
        @converted_return[:fundingProfiles][:currentFunding][:forecast] = @return[:fundingProfiles][:currentFunding][:forecast].map do |request|
          next if request.nil?
          new_profile = {
            period: request[:period],
            instalment1: request[:instalment1],
            instalment2: request[:instalment2],
            instalment3: request[:instalment3],
            instalment4: request[:instalment4],
            total: request.dig(:totalHolder, :total)
          }
          new_profile
        end
      end
    end

    @converted_return[:fundingProfiles][:changeRequired] = @return[:fundingProfiles][:changeRequired]
    @converted_return[:fundingProfiles][:reasonForRequest] = @return[:fundingProfiles][:reasonForRequest]
    @converted_return[:fundingProfiles][:mitigationInPlace] = @return[:fundingProfiles][:mitigationInPlace]

    unless @return[:fundingProfiles][:requestedProfiles].nil?
      unless @return[:fundingProfiles][:requestedProfiles][:newProfile].nil?
        @converted_return[:fundingProfiles][:requestedProfiles] = @return[:fundingProfiles][:requestedProfiles][:newProfile].map do |request|
          next if request.nil?

          new_request = { period: request[:period] }

          new_request[:newProfile] = {
            instalment1: request[:instalment1],
            instalment2: request[:instalment2],
            instalment3: request[:instalment3],
            instalment4: request[:instalment4],
            total: request.dig(:totalHolder, :total)
          }
          new_request
        end
      end
    end

    @converted_return[:fundingProfiles][:projectCashflows] = @return[:fundingProfiles][:projectCashflows]
  end

  def convert_funding_packages
    return if @return[:fundingPackages].nil?
    @converted_return[:fundingPackages] = @return[:fundingPackages].map do |package|

      next if package[:fundingStack].nil?

      new_package = {
        descriptionOfInfrastructure: package[:fundingStack][:descriptionOfInfrastructure]
      }

      new_package[:fundingStack] = {
        currentFundingStackDescription: package[:fundingStack][:currentFundingStackDescription]
      }

      unless package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn].nil?
        unless package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn][:hifSpendSinceLastReturnHolder].nil?
          new_package[:fundingStack][:hifSpendSinceLastReturn] = {
            currentReturn: package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn][:hifSpendSinceLastReturnHolder][:currentReturn],
            cumulativeIncCurrentReturn: package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn][:hifSpendSinceLastReturnHolder][:cumulativeIncCurrentReturn],
            cumulativeExCurrentReturn: package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn][:hifSpendSinceLastReturnHolder][:cumulativeExCurrentReturn],
            remaining: package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn][:hifSpendSinceLastReturnHolder][:remaining]
          }
        end
      end

      unless package[:fundingStack][:totalCost].nil?
        unless package[:fundingStack][:totalCost][:previousAmounts].nil?
          new_package[:fundingStack][:totalCost] = {
            baseline: package[:fundingStack][:totalCost][:previousAmounts][:baseline],
            lastReturn: package[:fundingStack][:totalCost][:previousAmounts][:lastReturn]
          }
        end

        new_package[:fundingStack][:totalCost][:anyChange] = package[:fundingStack][:totalCost][:anyChange]

        new_package[:fundingStack][:totalCost][:varianceReason] = package[:fundingStack][:totalCost][:varianceReason]

        unless package[:fundingStack][:totalCost][:areCostsFunded].nil?
          new_package[:fundingStack][:totalCost][:areCostsFunded] = {
            confirmation: package[:fundingStack][:totalCost][:areCostsFunded][:confirmation],
            fundingExplanation: package[:fundingStack][:totalCost][:areCostsFunded][:fundingExplanation],
            description: package[:fundingStack][:totalCost][:areCostsFunded][:description]
          }
        end

        unless package[:fundingStack][:totalCost][:variance].nil?
          new_package[:fundingStack][:totalCost][:current] = package[:fundingStack][:totalCost][:variance][:current]
          new_package[:fundingStack][:totalCost][:currentAmount] = package[:fundingStack][:totalCost][:variance][:currentAmount]


          new_package[:fundingStack][:totalCost][:variance] = {
            baseline: package[:fundingStack][:totalCost][:variance][:baseline],
            lastReturn: package[:fundingStack][:totalCost][:variance][:lastReturn]
          }
        end
      end
      unless package[:fundingStack][:fundedThroughHIF].nil?
        new_package[:fundingStack][:fundedThroughHIF] = package[:fundingStack][:fundedThroughHIF][:fundedThroughHIFCurrent]
        new_package[:fundingStack][:fundedThroughHIFbaseline] = package[:fundingStack][:fundedThroughHIF][:fundedThroughHIFbaseline]

        unless package[:fundingStack][:fundedThroughHIF][:anyChange].nil?
          new_package[:fundingStack][:anyChange] = {
            confirmation: package[:fundingStack][:fundedThroughHIF][:anyChange][:confirmation],
            descriptionOfChange: package[:fundingStack][:fundedThroughHIF][:anyChange][:descriptionOfChange]
          }
        end

        new_package[:fundingStack][:descriptionOfFundingStack] = package[:fundingStack][:fundedThroughHIF][:descriptionOfFundingStack]

        unless package[:fundingStack][:fundedThroughHIF][:anyChangeToDescription].nil?
          new_package[:fundingStack][:anyChangeToDescription] = {
            confirmation: package[:fundingStack][:fundedThroughHIF][:anyChangeToDescription][:confirmation],
            updatedFundingStack: package[:fundingStack][:fundedThroughHIF][:anyChangeToDescription][:updatedFundingStack]
          }
        end


        unless package[:fundingStack][:fundedThroughHIF][:hifSpend].nil?
          unless package[:fundingStack][:fundedThroughHIF][:hifSpend][:previousAmounts].nil?
            new_package[:fundingStack][:hifSpend] = {
              baseline: package[:fundingStack][:fundedThroughHIF][:hifSpend][:previousAmounts][:baseline],
              lastReturn: package[:fundingStack][:fundedThroughHIF][:hifSpend][:previousAmounts][:lastReturn]
            }
          end

          unless package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline].nil?
            new_package[:fundingStack][:hifSpend][:anyChangeToBaseline] = {
              confirmation: package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:confirmation]
            }
            new_package[:fundingStack][:hifSpend][:anyChangeToBaseline][:varianceReason] = package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:varianceReason]

            unless package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance].nil?
              new_package[:fundingStack][:hifSpend][:current] = package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance][:current]
              new_package[:fundingStack][:hifSpend][:currentAmount] = package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance][:currentAmount]

              new_package[:fundingStack][:hifSpend][:anyChangeToBaseline][:variance] = {
                baseline: package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance][:baseline],
                lastReturn: package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance][:lastReturn]
              }
            end
          end
        end

        unless package[:fundingStack][:fundedThroughHIF][:riskToFundingPackage].nil?
          new_package[:fundingStack][:riskToFundingPackage] = {
            risk: package[:fundingStack][:fundedThroughHIF][:riskToFundingPackage][:risk],
            description: package[:fundingStack][:fundedThroughHIF][:riskToFundingPackage][:description]
          }
        end

        unless package[:fundingStack][:fundedThroughHIF][:public].nil?
          new_package[:fundingStack][:public] = {}

          unless package[:fundingStack][:fundedThroughHIF][:public][:previousAmounts].nil?
            new_package[:fundingStack][:public] = {
              baseline: package[:fundingStack][:fundedThroughHIF][:public][:previousAmounts][:baseline],
              lastReturn: package[:fundingStack][:fundedThroughHIF][:public][:previousAmounts][:lastReturn]
            }
          end

          unless package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline].nil?
            new_package[:fundingStack][:public][:anyChangeToBaseline] = {
              confirmation: package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:confirmation]
            }
            new_package[:fundingStack][:public][:reason] = package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:reason]
            unless package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:variance].nil?
              new_package[:fundingStack][:public][:current] = package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:variance][:current]
              new_package[:fundingStack][:public][:currentAmount] = package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:variance][:currentAmount]
              new_package[:fundingStack][:public][:anyChangeToBaseline][:variance] = {
                baselineVariance: package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:variance][:baselineVariance],
                lastReturnVariance: package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:variance][:lastReturnVariance]
              }
            end
          end

          unless package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured].nil?
            new_package[:fundingStack][:public][:amountSecured] = package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:amountSecured]
            new_package[:fundingStack][:public][:amountSecuredLastReturn] = package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:amountSecuredLastReturn]
            new_package[:fundingStack][:public][:balancesSecured] = {
              remainingToBeSecured: package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:remainingToBeSecured],
              securedAgainstBaseline: package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:securedAgainstBaseline],
              securedAgainstBaselineLastReturn: package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:securedAgainstBaselineLastReturn],
              increaseOnLastReturn: package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:increaseOnLastReturn],
              increaseOnLastReturnPercent: package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured][:increaseOnLastReturnPercent]
            }
          end
        end

        unless package[:fundingStack][:fundedThroughHIF][:private].nil?
          new_package[:fundingStack][:private] = {}

          unless package[:fundingStack][:fundedThroughHIF][:private][:previousAmounts].nil?
            new_package[:fundingStack][:private] = {
              baseline: package[:fundingStack][:fundedThroughHIF][:private][:previousAmounts][:baseline],
              lastReturn: package[:fundingStack][:fundedThroughHIF][:private][:previousAmounts][:lastReturn]
            }
          end

          unless package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline].nil?
            new_package[:fundingStack][:private][:anyChangeToBaseline] = {
              confirmation: package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:confirmation]
            }
            new_package[:fundingStack][:private][:reason] = package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:reason]
            unless package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:variance].nil?
              new_package[:fundingStack][:private][:current] = package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:variance][:current]
              new_package[:fundingStack][:private][:currentAmount] = package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:variance][:currentAmount]

              new_package[:fundingStack][:private][:anyChangeToBaseline][:variance] = {
                baselineVariance: package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:variance][:baselineVariance],
                lastReturnVariance: package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:variance][:lastReturnVariance]
              }
            end
          end

          unless package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured].nil?
            new_package[:fundingStack][:private][:amountSecured] = package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:amountSecured]
            new_package[:fundingStack][:private][:amountSecuredLastReturn] = package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:amountSecuredLastReturn]
            new_package[:fundingStack][:private][:balancesSecured] = {
              remainingToBeSecured: package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:remainingToBeSecured],
              securedAgainstBaseline: package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:securedAgainstBaseline],
              securedAgainstBaselineLastReturn: package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:securedAgainstBaselineLastReturn],
              increaseOnLastReturn: package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:increaseOnLastReturn],
              increaseOnLastReturnPercent: package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured][:increaseOnLastReturnPercent]
            }
          end
        end
      end

      new_package
    end
  end

  def convert_wider_scheme
    return if @return[:widerScheme].nil?
    return if @return[:widerScheme][0].nil?

    @converted_return[:widerScheme] = [{}]

    unless @return[:widerScheme][0][:overview].nil?
      @converted_return[:widerScheme][0][:overview] = {
        developmentPlan: @return[:widerScheme][0][:overview][:developmentPlan]
      }
      unless @return[:widerScheme][0][:overview][:masterplan].nil?
        @converted_return[:widerScheme][0][:overview][:masterplan] = {
          confirmation: @return[:widerScheme][0][:overview][:masterplan][:confirmation],
          planAttachment: @return[:widerScheme][0][:overview][:masterplan][:planAttachment]
        }
      end
    end

    unless @return[:widerScheme][0][:keyLiveIssues].nil?
      @converted_return[:widerScheme][0][:keyLiveIssues] = @return[:widerScheme][0][:keyLiveIssues].map do |issue|
        next if issue.nil?
        new_issue = {
          description: issue[:description],
        }

        unless issue[:dates].nil?
          new_issue[:dates] = {
            dateRaised: issue[:dates][:dateRaised],
            estimatedCompletionDate: issue[:dates][:estimatedCompletionDate]
          }
        end

        unless issue[:currentdetails].nil?
          new_issue[:currentdetails] = {
            impact: issue[:currentdetails][:impact],
            currentStatus: issue[:currentdetails][:currentStatus],
            currentReturnLikelihood: issue[:currentdetails][:currentReturnLikelihood]
          }
        end

        new_issue[:mitigationActions] = issue[:mitigationActions]
        new_issue[:ratingAfterMitigation] = issue[:ratingAfterMitigation]

        new_issue
      end
    end

    unless @return[:widerScheme][0][:topRisks].nil?
      @converted_return[:widerScheme][0][:topRisks] = {}

      @converted_return[:widerScheme][0][:topRisks][:landAssembly] = convert_top_risk(@return[:widerScheme][0][:topRisks][:landAssembly])
      @converted_return[:widerScheme][0][:topRisks][:procurementInfrastructure] = convert_top_risk(@return[:widerScheme][0][:topRisks][:procurementInfrastructure])
      @converted_return[:widerScheme][0][:topRisks][:planningInfrastructure] = convert_top_risk(@return[:widerScheme][0][:topRisks][:planningInfrastructure])
      @converted_return[:widerScheme][0][:topRisks][:deliveryInfrastructure] = convert_top_risk(@return[:widerScheme][0][:topRisks][:deliveryInfrastructure])
      @converted_return[:widerScheme][0][:topRisks][:procurementHousing] = convert_top_risk(@return[:widerScheme][0][:topRisks][:procurementHousing])
      @converted_return[:widerScheme][0][:topRisks][:planningHousing] = convert_top_risk(@return[:widerScheme][0][:topRisks][:planningHousing])
      @converted_return[:widerScheme][0][:topRisks][:delivery] = convert_top_risk(@return[:widerScheme][0][:topRisks][:delivery])
      @converted_return[:widerScheme][0][:topRisks][:fundingPackage] = convert_top_risk(@return[:widerScheme][0][:topRisks][:fundingPackage])

      unless @return[:widerScheme][0][:topRisks][:additionalRisks].nil?
        @converted_return[:widerScheme][0][:topRisks][:additionalRisks] = @return[:widerScheme][0][:topRisks][:additionalRisks].map do |risk|
          convert_top_risk(risk)
        end
      end

      @converted_return[:widerScheme][0][:topRisks][:progressLastQuarter] = @return[:widerScheme][0][:topRisks][:progressLastQuarter]
      @converted_return[:widerScheme][0][:topRisks][:actionsLastQuarter] = @return[:widerScheme][0][:topRisks][:actionsLastQuarter]
      @converted_return[:widerScheme][0][:topRisks][:riskRegister] = @return[:widerScheme][0][:topRisks][:riskRegister]
    end
  end

  def convert_top_risk(risk)
    return if risk.nil?
    new_risk = {}

    new_risk[:varianceAmount] = risk[:varianceAmount]
    new_risk[:varianceReason] = risk[:varianceReason]
    new_risk[:baselineMitigationMeasures] = risk[:baselineMitigationMeasures]
    new_risk[:riskAfterMitigation] = risk[:riskAfterMitigation]

    unless risk[:riskHolder].nil?
      new_risk[:liveRisk] = risk[:riskHolder][:liveRisk]
      new_risk[:description] = risk[:riskHolder][:description]
    end

    unless risk[:dates].nil?
      new_risk[:dates] = {
        expectedCompletion: risk[:dates][:expectedCompletion],
        currentReturnCompletionDate: risk[:dates][:currentReturnCompletionDate]
      }
    end

    unless risk[:ratings].nil?
      new_risk[:ratings] = {
        baselineImpact: risk[:ratings][:baselineImpact],
        baselineLikelihood: risk[:ratings][:baselineLikelihood],
        currentReturnLikelihood: risk[:ratings][:currentReturnLikelihood]
      }
    end

    unless risk[:anyChange].nil?
      new_risk[:anyChange] = {
        confirmation: risk[:anyChange][:confirmation],
        updatedMeasures: risk[:anyChange][:updatedMeasures]
      }
    end

    unless risk[:riskMet].nil?
      new_risk[:riskMet] = {
        confirmation: risk[:riskMet][:confirmation],
        dateMet: risk[:riskMet][:dateMet]
      }
    end

    new_risk
  end

  def convert_outputs_forecast
    return if @return[:outputsForecast].nil?
    @converted_return[:outputsForecast] = {}

    unless @return[:outputsForecast][:summary].nil?
      @converted_return[:outputsForecast][:summary] = {
        totalUnits: @return[:outputsForecast][:summary][:totalUnits],
        disposalStrategy:@return[:outputsForecast][:summary][:disposalStrategy]
      }
    end

    unless @return[:outputsForecast][:housingStarts].nil?
      @converted_return[:outputsForecast][:housingStarts] = {}
      unless @return[:outputsForecast][:housingStarts][:baselineAmounts].nil?
        @converted_return[:outputsForecast][:housingStarts][:baselineAmounts] = @return[:outputsForecast][:housingStarts][:baselineAmounts].map do |amount|
          {
            period: amount[:period],
            baselineAmounts: amount[:baselineAmounts]
          }
        end
      end

      @converted_return[:outputsForecast][:housingStarts][:anyChanges] = @return[:outputsForecast][:housingStarts][:anyChanges]
      unless @return[:outputsForecast][:housingStarts][:currentReturnAmounts].nil?
        @converted_return[:outputsForecast][:housingStarts][:currentReturnAmounts] = @return[:outputsForecast][:housingStarts][:currentReturnAmounts].map do |amount|
          {
            period: amount[:period],
            currentReturnForecast: amount[:currentReturnForecast]
          }
        end
      end
    end

    unless @return[:outputsForecast][:inYearHousingStarts].nil?
      @converted_return[:outputsForecast][:inYearHousingStarts] = {
        progress: @return[:outputsForecast][:inYearHousingStarts][:progress]
      }

      unless @return[:outputsForecast][:inYearHousingStarts][:baselineAmounts].nil?
        @converted_return[:outputsForecast][:inYearHousingStarts][:baselineAmounts] = @return[:outputsForecast][:inYearHousingStarts][:baselineAmounts]
      end

      unless @return[:outputsForecast][:inYearHousingStarts][:currentAmounts].nil?
        @converted_return[:outputsForecast][:inYearHousingStarts][:currentAmounts] = @return[:outputsForecast][:inYearHousingStarts][:currentAmounts]
      end

      unless @return[:outputsForecast][:inYearHousingStarts][:actualAmounts].nil?
        @converted_return[:outputsForecast][:inYearHousingStarts][:actualAmounts] = @return[:outputsForecast][:inYearHousingStarts][:actualAmounts]
      end

      unless @return[:outputsForecast][:inYearHousingStarts][:newYear].nil?
        @converted_return[:outputsForecast][:inYearHousingStarts][:newYear] = {
          setNewAmounts: @return[:outputsForecast][:inYearHousingStarts][:newYear][:setNewAmounts],
          newStarts: @return[:outputsForecast][:inYearHousingStarts][:newYear][:newStarts]
        }
      end
    end

    unless @return[:outputsForecast][:housingCompletions].nil?
      @converted_return[:outputsForecast][:housingCompletions] = {}

      unless @return[:outputsForecast][:housingCompletions][:baselineAmounts].nil?
        @converted_return[:outputsForecast][:housingCompletions][:baselineAmounts] = @return[:outputsForecast][:housingCompletions][:baselineAmounts].map do |amount|
          {
            period: amount[:period],
            baselineAmounts: amount[:baselineAmounts]
          }
        end
      end

      @converted_return[:outputsForecast][:housingCompletions][:anyChanges] = @return[:outputsForecast][:housingCompletions][:anyChanges]

      unless @return[:outputsForecast][:housingCompletions][:currentReturnAmounts].nil?
        @converted_return[:outputsForecast][:housingCompletions][:currentReturnAmounts] = @return[:outputsForecast][:housingCompletions][:currentReturnAmounts].map do |amount|
          {
            period: amount[:period],
            currentReturnForecast: amount[:currentReturnForecast]
          }
        end
      end
    end

    unless @return[:outputsForecast][:inYearHousingCompletions].nil?
      @converted_return[:outputsForecast][:inYearHousingCompletions] = {
        progress: @return[:outputsForecast][:inYearHousingCompletions][:progress]
      }

      unless @return[:outputsForecast][:inYearHousingCompletions][:baselineAmounts].nil?
        @converted_return[:outputsForecast][:inYearHousingCompletions][:baselineAmounts] = @return[:outputsForecast][:inYearHousingCompletions][:baselineAmounts]
      end

      unless @return[:outputsForecast][:inYearHousingCompletions][:currentAmounts].nil?
        @converted_return[:outputsForecast][:inYearHousingCompletions][:currentAmounts] = @return[:outputsForecast][:inYearHousingCompletions][:currentAmounts]
      end

      unless @return[:outputsForecast][:inYearHousingCompletions][:actualAmounts].nil?
        @converted_return[:outputsForecast][:inYearHousingCompletions][:actualAmounts] = @return[:outputsForecast][:inYearHousingCompletions][:actualAmounts]
      end

      unless @return[:outputsForecast][:inYearHousingCompletions][:newYear].nil?
        @converted_return[:outputsForecast][:inYearHousingCompletions][:newYear] = {
          setNewAmounts: @return[:outputsForecast][:inYearHousingCompletions][:newYear][:setNewAmounts],
          newCompletions: @return[:outputsForecast][:inYearHousingCompletions][:newYear][:newCompletions]
        }
      end
    end
  end

  def convert_s151_confirmation
    return if @return[:s151Confirmation].nil?
    @converted_return[:s151Confirmation] = {}

    unless @return[:s151Confirmation][:hifFunding].nil?
      @converted_return[:s151Confirmation][:hifFunding] = {}
      unless @return[:s151Confirmation][:hifFunding][:changesToRequest].nil?
        @converted_return[:s151Confirmation][:hifFunding][:changesToRequest] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:changesToRequestConfirmation]
        @converted_return[:s151Confirmation][:hifFunding][:hifTotalFundingRequest] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:hifTotalFundingRequest]
        @converted_return[:s151Confirmation][:hifFunding][:requestedAmount] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:requestedAmount]
        @converted_return[:s151Confirmation][:hifFunding][:reasonForRequest] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:reasonForRequest]

        @converted_return[:s151Confirmation][:hifFunding][:varianceFromBaseline] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:variance]
        @converted_return[:s151Confirmation][:hifFunding][:varianceFromBaselinePercent] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:varianceFromBaselinePercent]

        @converted_return[:s151Confirmation][:hifFunding][:evidenceOfVariance] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:evidenceOfVariance]
        @converted_return[:s151Confirmation][:hifFunding][:mitigationInPlace] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:mitigationInPlace]
      end

      unless @return[:s151Confirmation][:hifFunding][:hifFundingProfile].nil?
        @converted_return[:s151Confirmation][:hifFunding][:hifFundingProfile] = @return[:s151Confirmation][:hifFunding][:hifFundingProfile].map do |profile|
          {
            period: profile[:period],
            instalment1: profile[:instalment1],
            instalment2: profile[:instalment2],
            instalment3: profile[:instalment3],
            instalment4: profile[:instalment4],
            total: profile[:total],
            baselineVariance1: profile[:baselineVariance1],
            baselineVariance2: profile[:baselineVariance2],
            baselineVariance3: profile[:baselineVariance3],
            baselineVariance4: profile[:baselineVariance4],
            lastMovement1: profile[:lastMovement1],
            lastMovement2: profile[:lastMovement2],
            lastMovement3: profile[:lastMovement3],
            lastMovement4: profile[:lastMovement4],
            movementVariance1: profile[:movementVariance1],
            movementVariance2: profile[:movementVariance2],
            movementVariance3: profile[:movementVariance3],
            movementVariance4: profile[:movementVariance4]
          }
        end
      end

      @converted_return[:s151Confirmation][:hifFunding][:amendmentConfirmation] = @return[:s151Confirmation][:hifFunding][:amendmentConfirmation]
      @converted_return[:s151Confirmation][:hifFunding][:cashflowConfirmation] = @return[:s151Confirmation][:hifFunding][:cashflowConfirmation]
    end

    return if @return[:s151Confirmation][:submission].nil?

    @converted_return[:s151Confirmation][:submission] = {
      signoff: @return[:s151Confirmation][:submission][:signoff],
      hifFundingEndDate: @return[:s151Confirmation][:submission][:hifFundingEndDate],
      projectLongstopDate: @return[:s151Confirmation][:submission][:projectLongstopDate]
      }
    unless @return[:s151Confirmation][:submission][:changeToMilestones].nil?
      @converted_return[:s151Confirmation][:submission][:changeToMilestones] = @return[:s151Confirmation][:submission][:changeToMilestones][:changeToMilestonesConfirmation]
      @converted_return[:s151Confirmation][:submission][:requestedAmendments] = @return[:s151Confirmation][:submission][:changeToMilestones][:requestedAmendments]
      @converted_return[:s151Confirmation][:submission][:reasonForRequestOfMilestoneChange] = @return[:s151Confirmation][:submission][:changeToMilestones][:reasonForRequestOfMilestoneChange]
      @converted_return[:s151Confirmation][:submission][:mitigationInPlaceMilestone] = @return[:s151Confirmation][:submission][:changeToMilestones][:mitigationInPlaceMilestone]
    end

    unless @return[:s151Confirmation][:submission][:changesToEndDate].nil?
      @converted_return[:s151Confirmation][:submission][:changesToEndDate] = @return[:s151Confirmation][:submission][:changesToEndDate][:changesToEndDateConfirmation]
      @converted_return[:s151Confirmation][:submission][:reasonForRequestOfDateChange] = @return[:s151Confirmation][:submission][:changesToEndDate][:reasonForRequestOfDateChange]
      @converted_return[:s151Confirmation][:submission][:requestedChangedEndDate] = @return[:s151Confirmation][:submission][:changesToEndDate][:requestedChangedEndDate]
      @converted_return[:s151Confirmation][:submission][:mitigationInPlaceEndDate] = @return[:s151Confirmation][:submission][:changesToEndDate][:mitigationInPlaceEndDate]
      @converted_return[:s151Confirmation][:submission][:varianceFromEndDateBaseline] = @return[:s151Confirmation][:submission][:changesToEndDate][:varianceFromEndDateBaseline]
      @converted_return[:s151Confirmation][:submission][:evidenceUpload] = @return[:s151Confirmation][:submission][:changesToEndDate][:evidenceUpload]
    end

    unless @return[:s151Confirmation][:submission][:changesToLongstopDate].nil?
      @converted_return[:s151Confirmation][:submission][:changesToLongstopDate] = @return[:s151Confirmation][:submission][:changesToLongstopDate][:changesToLongstopDateConfirmation]
      @converted_return[:s151Confirmation][:submission][:reasonForRequestOfLongstopChange] = @return[:s151Confirmation][:submission][:changesToLongstopDate][:reasonForRequestOfLongstopChange]
      @converted_return[:s151Confirmation][:submission][:requestedLongstopEndDate] = @return[:s151Confirmation][:submission][:changesToLongstopDate][:requestedLongstopEndDate]
      @converted_return[:s151Confirmation][:submission][:varianceFromLongStopBaseline] = @return[:s151Confirmation][:submission][:changesToLongstopDate][:varianceFromLongStopBaseline]
      @converted_return[:s151Confirmation][:submission][:mitigationInPlaceLongstopDate] = @return[:s151Confirmation][:submission][:changesToLongstopDate][:mitigationInPlaceLongstopDate]
      @converted_return[:s151Confirmation][:submission][:evidenceUploadLongstopDate] = @return[:s151Confirmation][:submission][:changesToLongstopDate][:evidenceUploadLongstopDate]
    end

    unless @return[:s151Confirmation][:submission][:recoverFunding].nil?
      @converted_return[:s151Confirmation][:submission][:recoverFunding] = @return[:s151Confirmation][:submission][:recoverFunding][:recoverFundingConfirmation]
      @converted_return[:s151Confirmation][:submission][:usedOnFutureHosuing] = @return[:s151Confirmation][:submission][:recoverFunding][:usedOnFutureHousing]
    end
  end

  def convert_s151
    return if @return[:s151].nil?
    @converted_return[:s151] = {}

    unless @return[:s151][:claimSummary].nil?
      @converted_return[:s151][:claimSummary] = {
        hifTotalFundingRequest: @return[:s151][:claimSummary][:hifTotalFundingRequest],
        hifSpendToDate: @return[:s151][:claimSummary][:hifSpendToDate],
        AmountOfThisClaim: @return[:s151][:claimSummary][:AmountOfThisClaim],
        certifiedClaimForm: @return[:s151][:claimSummary][:certifiedClaimForm],
        runningClaimTotal: @return[:s151][:claimSummary][:runningClaimTotal]
      }
    end

    return if @return[:s151][:supportingEvidence].nil?
    @converted_return[:s151][:supportingEvidence] = {}

    unless @return[:s151][:supportingEvidence][:lastQuarterMonthSpend].nil?
      @converted_return[:s151][:supportingEvidence][:lastQuarterMonthSpend] = {
        forecast: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:forecast],
        actual: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:actual],
        varianceReason: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:varianceReason]
      }
      unless @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance].nil?
        @converted_return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance] = {
          varianceAgainstForcastAmount: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance][:varianceAgainstForcastAmount],
          varianceAgainstForcastPercentage: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance][:varianceAgainstForcastPercentage]
        }
      end
    end

    @converted_return[:s151][:supportingEvidence][:evidenceOfSpendPastQuarter] = @return[:s151][:supportingEvidence][:evidenceOfSpendPastQuarter]

    return if @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend].nil?

    @converted_return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend] = {
      forecast: @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend][:forecast],
      descriptionOfSpend: @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend][:descriptionOfSpend],
      evidenceOfSpendNextQuarter: @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend][:evidenceOfSpendNextQuarter]
    }
  end

  def convert_rm_monthly_catchup
    @converted_return[:rmMonthlyCatchup] = {
      catchUp: [{}]
    }
    return if @return[:rmMonthlyCatchup].nil?

    unless @return[:rmMonthlyCatchup][:catchUp].nil?
      @converted_return[:rmMonthlyCatchup][:catchUp] = @return[:rmMonthlyCatchup][:catchUp].map do |catch_up|
        next if catch_up.nil?
        new_catch_up = {}
        new_catch_up[:dateOfCatchUp] = catch_up[:dateOfCatchUp]
        new_catch_up[:overallRatingForScheme] = catch_up[:overallRatingForScheme]
        unless catch_up[:redBarriers].nil?
          new_catch_up[:redBarriers] = catch_up[:redBarriers].map do |red_barrier|
            next if red_barrier.nil?
            {
              barrier: red_barrier[:barrier],
              overview: red_barrier[:overview],
              description: red_barrier[:description]
            }
          end
        end

        unless catch_up[:amberBarriers].nil?
          new_catch_up[:amberBarriers] = catch_up[:amberBarriers].map do |amber_barrier|
            next if amber_barrier.nil?
            {
              barrier: amber_barrier[:barrier],
              overview: amber_barrier[:overview],
              description: amber_barrier[:description]
            }
          end
        end

        new_catch_up[:overviewOfEngagement] = catch_up[:overviewOfEngagement]
        new_catch_up[:commentOnProgress] = catch_up[:commentOnProgress]
        new_catch_up[:issuesToRaise] = catch_up[:issuesToRaise]

        new_catch_up
      end
    end
  end

  def convert_outputs_actuals
    return if @return[:outputsActuals].nil?
    @converted_return[:outputsActuals] = @return[:outputsActuals].map do |site_output|
      new_site_output = {}

      next if site_output[:siteOutputs].nil?

      unless site_output[:siteOutputs][:details].nil?
        new_site_output[:localAuthority] = site_output[:siteOutputs][:details][:localAuthority]
        new_site_output[:noOfUnits] = site_output[:siteOutputs][:details][:noOfUnits]
        new_site_output[:size] = site_output[:siteOutputs][:details][:size]
      end

      unless site_output[:siteOutputs][:starts].nil?
        unless site_output[:siteOutputs][:starts][:starts].nil?
          new_site_output[:previousStarts] = site_output[:siteOutputs][:starts][:starts][:previousStarts]
          new_site_output[:startsSinceLastReturn] = site_output[:siteOutputs][:starts][:starts][:startsSinceLastReturn]
          new_site_output[:previousCompletions] = site_output[:siteOutputs][:starts][:starts][:previousCompletions]
          new_site_output[:completionsSinceLastReturn] = site_output[:siteOutputs][:starts][:starts][:completionsSinceLastReturn]
          new_site_output[:currentStarts] = site_output[:siteOutputs][:starts][:starts][:currentStarts]
          new_site_output[:currentCompletions] = site_output[:siteOutputs][:starts][:starts][:currentCompletions]
        end
      end

      unless site_output[:siteOutputs][:ownership].nil?
        new_site_output[:laOwned] = site_output[:siteOutputs][:ownership][:laOwned]
        new_site_output[:pslLand] = site_output[:siteOutputs][:ownership][:pslLand]
      end

      unless site_output[:siteOutputs][:percentages].nil?
        new_site_output[:brownfieldPercent] = site_output[:siteOutputs][:percentages][:brownfieldPercent]
        new_site_output[:leaseholdPercent] = site_output[:siteOutputs][:percentages][:leaseholdPercent]
        new_site_output[:smePercent] = site_output[:siteOutputs][:percentages][:smePercent]
        new_site_output[:mmcPercent] = site_output[:siteOutputs][:percentages][:mmcPercent]
      end

      new_site_output
    end
  end

  def convert_mr_review_tab
    return if @return[:reviewAndAssurance].nil?
    @converted_return[:reviewAndAssurance] = {}
    unless @return[:reviewAndAssurance].nil?
      @converted_return[:reviewAndAssurance][:attendance] = @return[:reviewAndAssurance][:attendance]
      unless @return[:reviewAndAssurance][:meetingDetails].nil?
        @converted_return[:reviewAndAssurance][:date] = @return[:reviewAndAssurance][:meetingDetails][:date]
        @converted_return[:reviewAndAssurance][:meetingHeld] = @return[:reviewAndAssurance][:meetingDetails][:meetingHeld]
      end

      @converted_return[:reviewAndAssurance][:meetingsAttended] = @return[:reviewAndAssurance][:meetingsAttended]

      unless @return[:reviewAndAssurance][:infrastructureDelivery].nil?
        @converted_return[:reviewAndAssurance][:infrastructureDeliveries] = @return[:reviewAndAssurance][:infrastructureDelivery].map do |delivery|
          new_delivery = {
            infrastructureDesc: delivery[:infrastructureDesc]
          }
          unless delivery[:reviewDetails].nil?
            new_delivery[:details] = delivery[:reviewDetails][:details]
            new_delivery[:riskRating] = delivery[:reviewDetails][:riskRating]
          end
          new_delivery
        end
      end

      unless @return[:reviewAndAssurance][:hifFundedFinancials].nil?
        @converted_return[:reviewAndAssurance][:hifFundedFinancials] = {}
        @converted_return[:reviewAndAssurance][:hifFundedFinancials][:summary] = @return[:reviewAndAssurance][:hifFundedFinancials][:summary]
        @converted_return[:reviewAndAssurance][:hifFundedFinancials][:riskRating] = @return[:reviewAndAssurance][:hifFundedFinancials][:riskRating]
      end

      unless @return[:reviewAndAssurance][:hifWiderScheme].nil?
        @converted_return[:reviewAndAssurance][:hifWiderScheme] = {}
        @converted_return[:reviewAndAssurance][:hifWiderScheme][:summary] = @return[:reviewAndAssurance][:hifWiderScheme][:summary]
        @converted_return[:reviewAndAssurance][:hifWiderScheme][:riskRating] = @return[:reviewAndAssurance][:hifWiderScheme][:riskRating]
      end

      unless @return[:reviewAndAssurance][:outputForecast].nil?
        @converted_return[:reviewAndAssurance][:outputForecast] = {}
        @converted_return[:reviewAndAssurance][:outputForecast][:summary] = @return[:reviewAndAssurance][:outputForecast][:summary]
        @converted_return[:reviewAndAssurance][:outputForecast][:riskRating] = @return[:reviewAndAssurance][:outputForecast][:riskRating]
      end

      unless @return[:reviewAndAssurance][:barriers].nil?
        @converted_return[:reviewAndAssurance][:barriers] = {}
        unless @return[:reviewAndAssurance][:barriers][:significantIssues].nil?
          @converted_return[:reviewAndAssurance][:barriers][:significantIssues] = @return[:reviewAndAssurance][:barriers][:significantIssues].map do |issue|
            {
              overview: issue[:overview],
              barrierType: issue[:barrierType],
              commentary: issue[:commentary],
              details: issue[:details]
            }
          end
        end

        unless @return[:reviewAndAssurance][:barriers][:liveIssues].nil?
          @converted_return[:reviewAndAssurance][:barriers][:liveIssues] = @return[:reviewAndAssurance][:barriers][:liveIssues].map do |issue|
            {
              overview: issue[:overview],
              barrierType: issue[:barrierType],
              commentary: issue[:commentary],
              details: issue[:details]
            }
          end
        end
      end

      @converted_return[:reviewAndAssurance][:assuranceReview] = {}

      @converted_return[:reviewAndAssurance][:assuranceReview][:summaryOfMeeting] = @return[:reviewAndAssurance][:summaryOfMeeting]

      unless @return[:reviewAndAssurance][:overallRAGRating].nil?
        @converted_return[:reviewAndAssurance][:assuranceReview][:overallRAGRating] = @return[:reviewAndAssurance][:overallRAGRating]
      end

      @converted_return[:reviewAndAssurance][:assuranceReview][:overallCommentary] = @return[:reviewAndAssurance][:overallCommentary]
      unless @return[:reviewAndAssurance][:riskAssessmentSpend].nil?
        @converted_return[:reviewAndAssurance][:assuranceReview][:riskAssessmentSpend] = @return[:reviewAndAssurance][:riskAssessmentSpend]
      end

      unless @return[:reviewAndAssurance][:riskAssessmentOutputs].nil?
        @converted_return[:reviewAndAssurance][:assuranceReview][:riskAssessmentOutputs] = @return[:reviewAndAssurance][:riskAssessmentOutputs]
      end

      unless @return[:reviewAndAssurance][:raisedIssues].nil?
        @converted_return[:reviewAndAssurance][:assuranceReview][:raisedIssues] = @return[:reviewAndAssurance][:raisedIssues]
      end

      unless @return[:reviewAndAssurance][:recommendForRegularMonitoring].nil?
        @converted_return[:reviewAndAssurance][:assuranceReview][:moreRegularMonitoring] = @return[:reviewAndAssurance][:recommendForRegularMonitoring]
      end

      @converted_return[:reviewAndAssurance][:assuranceReview][:commentary] = @return[:reviewAndAssurance][:commentary]
    end
  end

  def convert_hif_recovery_tab
    return if @return[:hifRecovery].nil?

    @converted_return[:hifRecovery] = @return[:hifRecovery]
  end
end
