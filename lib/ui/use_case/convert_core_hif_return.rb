# frozen_string_literal: true
class UI::UseCase::ConvertCoreHIFReturn
  def execute(return_data:)
    @return = return_data
    @converted_return = {}

    convert_infrastructures
    convert_funding_packages
    convert_funding_profiles
    convert_wider_scheme
    convert_outputs_forecast
    convert_outputs_actuals
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

    unless planning[:section106].nil?
      new_planning[:section106] = {
        s106Requirement: planning[:section106][:s106Requirement],
        s106SummaryOfRequirement: planning[:section106][:s106SummaryOfRequirement]
      }
      unless planning[:section106][:statutoryConsents].nil?
        new_planning[:statutoryConsents] = {
          anyStatutoryConsents: planning[:section106][:statutoryConsents][:anyStatutoryConsents]
        }
        unless planning[:section106][:statutoryConsents][:statutoryConsents].nil?
          new_planning[:statutoryConsents][:statutoryConsents] = planning[:section106][:statutoryConsents][:statutoryConsents].map do |consent|
            next if consent.nil?
            new_consent = {
              detailsOfConsent: consent[:detailsOfConsent]
            }
            new_consent[:statusOfConsent] = {
              baseline: consent[:baselineCompletion],
              status: consent[:statusAgainstLastReturn],
              percentComplete: consent[:percentComplete],
              completedDate: consent[:completionDate],
              current: consent[:currentReturn],
              previousReturn: consent[:previousReturn],
              varianceAgainstBaseline: consent[:varianceAgainstBaseline],
              varianceAgainstLastReturn: consent[:varianceAgainstLastReturn],
              reason: consent[:varianceReason]
            }
            new_consent
          end
        end
      end
    end

    new_planning
  end

  def convert_land_ownership(land_ownership)
    new_land_ownership = {
      landControl: {
        laHasControlOfSite: land_ownership[:laHasControlOfSite]
      }
    }

    unless land_ownership[:laDoesNotControlSite].nil?
      new_land_ownership[:landControl][:laDoesNotControlSite] = {
        whoOwnsSite: land_ownership[:laDoesNotControlSite][:whoOwnsSite]
      }

      new_land_ownership[:acquisitionRequired] = {
        landAcquisitionRequired: land_ownership[:laDoesNotControlSite][:landAcquisitionRequired],
        howManySitesToAquire: land_ownership[:laDoesNotControlSite][:howManySitesToAquire],
        toBeAquiredBy: land_ownership[:laDoesNotControlSite][:toBeAquiredBy],
        summaryOfAcquisitionRequired: land_ownership[:laDoesNotControlSite][:summaryOfAcquisitionRequired],
        allLandAssemblyAchieved: land_ownership[:laDoesNotControlSite][:allLandAssemblyAchieved]
      }
    end

    new_land_ownership
  end

  def convert_procurement(procurement)
    new_procurement = {
      contractorProcured: procurement[:contractorProcured],
      nameOfContractor: procurement[:nameOfContractor],
      summaryOfCriticalPath: procurement[:summaryOfCriticalPath],
    }
    new_procurement[:procurementStatusAgainstLastReturn] = {}

    unless procurement[:procurementStatusAgainstLastReturn].nil?
      new_procurement[:procurementStatusAgainstLastReturn] = {
        status: procurement[:procurementStatusAgainstLastReturn][:statusAgainstLastReturn],
        current: procurement[:procurementStatusAgainstLastReturn][:currentReturn],
        reason: procurement[:procurementStatusAgainstLastReturn][:reasonForVariance],
        previousReturn: procurement[:procurementStatusAgainstLastReturn][:previousReturn]
      }
    end

    new_procurement[:procurementStatusAgainstLastReturn][:baseline] = procurement[:procurementBaselineCompletion]
    new_procurement[:procurementStatusAgainstLastReturn][:procurementVarianceAgainstLastReturn] = procurement[:procurementVarianceAgainstLastReturn]
    new_procurement[:procurementStatusAgainstLastReturn][:procurementVarianceAgainstBaseline] = procurement[:procurementVarianceAgainstBaseline]
    new_procurement[:procurementStatusAgainstLastReturn][:percentComplete] = procurement[:percentComplete]
    new_procurement[:procurementStatusAgainstLastReturn][:completedDate] = procurement[:procurementCompletedDate]
    new_procurement[:procurementStatusAgainstLastReturn][:onCompletedNameOfContractor] = procurement[:procurementCompletedNameOfContractor]

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
    new_milestones[:startAndCompletionMilestones] = {
      expectedInfrastructureStartOnSite: milestones[:expectedInfrastructureStartOnSite],
      expectedCompletionDateOfInfra: milestones[:expectedCompletionDateOfInfra]
    }

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
        new_risk[:riskMet] = risk[:riskMetDate]
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
          description: risk[:riskBaselineRisk],
          impact: risk[:riskBaselineImpact],
          likelihood: risk[:riskBaselineLikelihood],
          riskCurrentReturnLikelihood: risk[:riskCurrentReturnLikelihood],
          mitigations: risk[:riskBaselineMitigationsInPlace],
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
      @converted_return[:fundingProfiles][:fundingRequest] = {}
      @converted_return[:fundingProfiles][:fundingRequest][:forecast] = @return[:fundingProfiles][:fundingRequest].map do |request|
        next if request.nil?
        new_request = { period: request[:period] }

        next new_request if request[:forecast].nil?

        new_request[:instalment1] = request[:forecast][:instalment1]
        new_request[:instalment2] = request[:forecast][:instalment2]
        new_request[:instalment3] = request[:forecast][:instalment3]
        new_request[:instalment4] = request[:forecast][:instalment4]

        new_request[:totalHolder] = {}
        new_request[:totalHolder][:total] = request[:forecast][:total]

        new_request
      end
    end

    unless @return[:fundingProfiles][:currentFunding].nil?
      unless @return[:fundingProfiles][:currentFunding][:forecast].nil?
        @converted_return[:fundingProfiles][:currentFunding] = {}
        @converted_return[:fundingProfiles][:currentFunding][:forecast] = @return[:fundingProfiles][:currentFunding][:forecast].map do |request|
          next if request.nil?
          {
            period: request[:period],
            instalment1: request[:instalment1],
            instalment2: request[:instalment2],
            instalment3: request[:instalment3],
            instalment4: request[:instalment4],
            totalHolder: { total: request[:total] }
          }
        end
      end
    end


    @converted_return[:fundingProfiles][:changeRequired] = @return[:fundingProfiles][:changeRequired]
    @converted_return[:fundingProfiles][:reasonForRequest] = @return[:fundingProfiles][:reasonForRequest]
    @converted_return[:fundingProfiles][:mitigationInPlace] = @return[:fundingProfiles][:mitigationInPlace]

    unless @return[:fundingProfiles][:requestedProfiles].nil?
      @converted_return[:fundingProfiles][:requestedProfiles] = {}
      @converted_return[:fundingProfiles][:requestedProfiles][:newProfile] = @return[:fundingProfiles][:requestedProfiles].map do |request|
        next if request.nil?

        new_request = { period: request[:period] }

        next new_request if request[:newProfile].nil?

        new_request[:instalment1] = request[:newProfile][:instalment1]
        new_request[:instalment2] = request[:newProfile][:instalment2]
        new_request[:instalment3] = request[:newProfile][:instalment3]
        new_request[:instalment4] = request[:newProfile][:instalment4]

        new_request[:totalHolder] = {}
        new_request[:totalHolder][:total] = request[:newProfile][:total]

        new_request
      end
    end

    @converted_return[:fundingProfiles][:projectCashflows] = @return[:fundingProfiles][:projectCashflows]

  end

  def convert_funding_packages
    return if @return[:fundingPackages].nil?
    @converted_return[:fundingPackages] = @return[:fundingPackages].map do |package|
      new_package = {}

      next if package[:fundingStack].nil?

      new_package[:fundingStack] = {
        descriptionOfInfrastructure: package[:descriptionOfInfrastructure],
        currentFundingStackDescription: package[:fundingStack][:currentFundingStackDescription]
      }

      unless package[:fundingStack][:totalCost].nil?
        new_package[:fundingStack][:totalCost] = {
          previousAmounts: {
            baseline: package[:fundingStack][:totalCost][:baseline],
            lastReturn: package[:fundingStack][:totalCost][:lastReturn]
          },
          anyChange: package[:fundingStack][:totalCost][:anyChange],
          varianceReason: package[:fundingStack][:totalCost][:varianceReason]
        }

        unless package[:fundingStack][:totalCost][:areCostsFunded].nil?
          new_package[:fundingStack][:totalCost][:areCostsFunded] = {
            confirmation: package[:fundingStack][:totalCost][:areCostsFunded][:confirmation],
            fundingExplanation: package[:fundingStack][:totalCost][:areCostsFunded][:fundingExplanation],
            description: package[:fundingStack][:totalCost][:areCostsFunded][:description]
          }
        end

        new_package[:fundingStack][:totalCost][:variance] = {
            current: package[:fundingStack][:totalCost][:current],
            currentAmount: package[:fundingStack][:totalCost][:currentAmount]
          }

        unless package[:fundingStack][:totalCost][:variance].nil?
          new_package[:fundingStack][:totalCost][:variance][:baseline] = package[:fundingStack][:totalCost][:variance][:baseline]
          new_package[:fundingStack][:totalCost][:variance][:lastReturn] = package[:fundingStack][:totalCost][:variance][:lastReturn]
        end
      end

      new_package[:fundingStack][:fundedThroughHIF] = {
        fundedThroughHIFCurrent: package[:fundingStack][:fundedThroughHIF],
        fundedThroughHIFbaseline: package[:fundingStack][:fundedThroughHIFbaseline]
      }

      unless package[:fundingStack][:anyChange].nil?
        new_package[:fundingStack][:fundedThroughHIF][:anyChange] = {
          confirmation: package[:fundingStack][:anyChange][:confirmation],
          descriptionOfChange: package[:fundingStack][:anyChange][:descriptionOfChange]
        }
      end

      new_package[:fundingStack][:fundedThroughHIF][:descriptionOfFundingStack] = package[:fundingStack][:descriptionOfFundingStack]

      unless package[:fundingStack][:anyChangeToDescription].nil?
        new_package[:fundingStack][:fundedThroughHIF][:anyChangeToDescription] = {
          confirmation: package[:fundingStack][:anyChangeToDescription][:confirmation],
          updatedFundingStack: package[:fundingStack][:anyChangeToDescription][:updatedFundingStack]
        }
      end

      unless package[:fundingStack][:hifSpend].nil?
        new_package[:fundingStack][:fundedThroughHIF][:hifSpend] = {
          previousAmounts: {
            baseline: package[:fundingStack][:hifSpend][:baseline],
            lastReturn: package[:fundingStack][:hifSpend][:lastReturn]
          }
        }
        unless package[:fundingStack][:hifSpendSinceLastReturn].nil?
          new_package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn] = {}

          new_package[:fundingStack][:fundedThroughHIF][:hifSpend][:hifSpendSinceLastReturn][:hifSpendSinceLastReturnHolder] = {
            currentReturn: package[:fundingStack][:hifSpendSinceLastReturn][:currentReturn],
            cumulativeIncCurrentReturn: package[:fundingStack][:hifSpendSinceLastReturn][:cumulativeIncCurrentReturn],
            cumulativeExCurrentReturn: package[:fundingStack][:hifSpendSinceLastReturn][:cumulativeExCurrentReturn],
            remaining: package[:fundingStack][:hifSpendSinceLastReturn][:remaining]
          }
        end

        unless package[:fundingStack][:hifSpend][:anyChangeToBaseline].nil?
          new_package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline] = {
            confirmation: package[:fundingStack][:hifSpend][:anyChangeToBaseline][:confirmation],
            varianceReason: package[:fundingStack][:hifSpend][:anyChangeToBaseline][:varianceReason]
          }

          new_package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance] = {
            current: package[:fundingStack][:hifSpend][:current],
            currentAmount: package[:fundingStack][:hifSpend][:currentAmount]
          }

          unless package[:fundingStack][:hifSpend][:anyChangeToBaseline][:variance].nil?
            new_package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance][:baseline] = package[:fundingStack][:hifSpend][:anyChangeToBaseline][:variance][:baseline]
            new_package[:fundingStack][:fundedThroughHIF][:hifSpend][:anyChangeToBaseline][:variance][:lastReturn] = package[:fundingStack][:hifSpend][:anyChangeToBaseline][:variance][:lastReturn]
          end
        end
      end

      unless package[:fundingStack][:riskToFundingPackage].nil?
        new_package[:fundingStack][:fundedThroughHIF][:riskToFundingPackage] = {
          risk: package[:fundingStack][:riskToFundingPackage][:risk],
          description: package[:fundingStack][:riskToFundingPackage][:description]
        }
      end

      unless package[:fundingStack][:public].nil?
        new_package[:fundingStack][:fundedThroughHIF][:public] = {
          previousAmounts: {
            baseline: package[:fundingStack][:public][:baseline],
            lastReturn: package[:fundingStack][:public][:lastReturn]
          }
        }

        unless package[:fundingStack][:public][:anyChangeToBaseline].nil?
          new_package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline] = {
            reason: package[:fundingStack][:public][:reason],
            confirmation: package[:fundingStack][:public][:anyChangeToBaseline][:confirmation]
          }
          unless package[:fundingStack][:public][:anyChangeToBaseline][:variance].nil?
            new_package[:fundingStack][:fundedThroughHIF][:public][:anyChangeToBaseline][:variance] = {
              current: package[:fundingStack][:public][:current],
              currentAmount: package[:fundingStack][:public][:currentAmount],
              baselineVariance: package[:fundingStack][:public][:anyChangeToBaseline][:variance][:baselineVariance],
              lastReturnVariance: package[:fundingStack][:public][:anyChangeToBaseline][:variance][:lastReturnVariance]
            }
          end
        end

        unless package[:fundingStack][:public][:balancesSecured].nil?
          new_package[:fundingStack][:fundedThroughHIF][:public][:balancesSecured] = {
            amountSecured: package[:fundingStack][:public][:amountSecured],
            amountSecuredLastReturn: package[:fundingStack][:public][:amountSecuredLastReturn],
            remainingToBeSecured: package[:fundingStack][:public][:balancesSecured][:remainingToBeSecured],
            securedAgainstBaseline: package[:fundingStack][:public][:balancesSecured][:securedAgainstBaseline],
            securedAgainstBaselineLastReturn: package[:fundingStack][:public][:balancesSecured][:securedAgainstBaselineLastReturn],
            increaseOnLastReturn: package[:fundingStack][:public][:balancesSecured][:increaseOnLastReturn],
            increaseOnLastReturnPercent: package[:fundingStack][:public][:balancesSecured][:increaseOnLastReturnPercent]
          }
        end
      end

      unless package[:fundingStack][:private].nil?
        new_package[:fundingStack][:fundedThroughHIF][:private] = {
          previousAmounts: {
            baseline: package[:fundingStack][:private][:baseline],
            lastReturn: package[:fundingStack][:private][:lastReturn]
          }
        }

        new_package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline] = {
          reason: package[:fundingStack][:private][:reason]
        }

        unless package[:fundingStack][:private][:anyChangeToBaseline].nil?
          new_package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:confirmation] = package[:fundingStack][:private][:anyChangeToBaseline][:confirmation]

          unless package[:fundingStack][:private][:anyChangeToBaseline][:variance].nil?
            new_package[:fundingStack][:fundedThroughHIF][:private][:anyChangeToBaseline][:variance] = {
              current: package[:fundingStack][:private][:current],
              currentAmount: package[:fundingStack][:private][:currentAmount],
              baselineVariance: package[:fundingStack][:private][:anyChangeToBaseline][:variance][:baselineVariance],
              lastReturnVariance: package[:fundingStack][:private][:anyChangeToBaseline][:variance][:lastReturnVariance]
            }
          end
        end

        unless package[:fundingStack][:private][:balancesSecured].nil?
          new_package[:fundingStack][:fundedThroughHIF][:private][:balancesSecured] = {
            amountSecured: package[:fundingStack][:private][:amountSecured],
            amountSecuredLastReturn: package[:fundingStack][:private][:amountSecuredLastReturn],
            remainingToBeSecured: package[:fundingStack][:private][:balancesSecured][:remainingToBeSecured],
            securedAgainstBaseline: package[:fundingStack][:private][:balancesSecured][:securedAgainstBaseline],
            securedAgainstBaselineLastReturn: package[:fundingStack][:private][:balancesSecured][:securedAgainstBaselineLastReturn],
            increaseOnLastReturn: package[:fundingStack][:private][:balancesSecured][:increaseOnLastReturn],
            increaseOnLastReturnPercent: package[:fundingStack][:private][:balancesSecured][:increaseOnLastReturnPercent]
          }
        end
      end

      new_package
    end
  end

  def convert_wider_scheme
    @converted_return[:widerScheme] = [{keyLiveIssues: [{}]}]
    return if @return[:widerScheme].nil?

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
    new_risk = {
      riskHolder: {
        liveRisk: risk[:liveRisk],
        description: risk[:description],
      },
      varianceAmount: risk[:varianceAmount],
      varianceReason: risk[:varianceReason],
      baselineMitigationMeasures: risk[:baselineMitigationMeasures],
      riskAfterMitigation: risk[:riskAfterMitigation]
    }

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

      @converted_return[:s151Confirmation][:hifFunding][:changesToRequest] = {
        hifTotalFundingRequest: @return[:s151Confirmation][:hifFunding][:hifTotalFundingRequest],
        changesToRequestConfirmation: @return[:s151Confirmation][:hifFunding][:changesToRequest],
        requestedAmount: @return[:s151Confirmation][:hifFunding][:requestedAmount],
        reasonForRequest: @return[:s151Confirmation][:hifFunding][:reasonForRequest],
        evidenceOfVariance: @return[:s151Confirmation][:hifFunding][:evidenceOfVariance],
        mitigationInPlace: @return[:s151Confirmation][:hifFunding][:mitigationInPlace],
        varianceFromBaselinePercent: @return[:s151Confirmation][:hifFunding][:varianceFromBaselinePercent],
        variance: @return[:s151Confirmation][:hifFunding][:varianceFromBaseline]
      }
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
      hifFundingEndDate: @return[:s151Confirmation][:submission][:hifFundingEndDate],
      projectLongstopDate: @return[:s151Confirmation][:submission][:projectLongstopDate],
      signoff: @return[:s151Confirmation][:submission][:signoff]
    }

    @converted_return[:s151Confirmation][:submission][:recoverFunding] = {
      recoverFundingConfirmation: @return[:s151Confirmation][:submission][:recoverFunding],
      usedOnFutureHousing: @return[:s151Confirmation][:submission][:usedOnFutureHosuing]
    }

    @converted_return[:s151Confirmation][:submission][:changesToLongstopDate] = {
      changesToLongstopDateConfirmation: @return[:s151Confirmation][:submission][:changesToLongstopDate],
      reasonForRequestOfLongstopChange: @return[:s151Confirmation][:submission][:reasonForRequestOfLongstopChange],
      requestedLongstopEndDate: @return[:s151Confirmation][:submission][:requestedLongstopEndDate],
      varianceFromLongStopBaseline: @return[:s151Confirmation][:submission][:varianceFromLongStopBaseline],
      mitigationInPlaceLongstopDate: @return[:s151Confirmation][:submission][:mitigationInPlaceLongstopDate],
      evidenceUploadLongstopDate: @return[:s151Confirmation][:submission][:evidenceUploadLongstopDate]

    }

    @converted_return[:s151Confirmation][:submission][:changeToMilestones] = {
      requestedAmendments: @return[:s151Confirmation][:submission][:requestedAmendments],
      changeToMilestonesConfirmation: @return[:s151Confirmation][:submission][:changeToMilestones],
      reasonForRequestOfMilestoneChange: @return[:s151Confirmation][:submission][:reasonForRequestOfMilestoneChange],
      mitigationInPlaceMilestone: @return[:s151Confirmation][:submission][:mitigationInPlaceMilestone]
    }

    @converted_return[:s151Confirmation][:submission][:changesToEndDate] = {
      changesToEndDateConfirmation: @return[:s151Confirmation][:submission][:changesToEndDate],
      reasonForRequestOfDateChange: @return[:s151Confirmation][:submission][:reasonForRequestOfDateChange],
      requestedChangedEndDate: @return[:s151Confirmation][:submission][:requestedChangedEndDate],
      mitigationInPlaceEndDate: @return[:s151Confirmation][:submission][:mitigationInPlaceEndDate],
      varianceFromEndDateBaseline: @return[:s151Confirmation][:submission][:varianceFromEndDateBaseline],
      evidenceUpload: @return[:s151Confirmation][:submission][:evidenceUpload]
    }
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
      new_site_output = {
        siteOutputs: {}
      }

      new_site_output[:siteOutputs][:details] = {
        localAuthority: site_output[:localAuthority],
        noOfUnits: site_output[:noOfUnits],
        size: site_output[:size]
      }

      new_site_output[:siteOutputs][:starts] = {}

      new_site_output[:siteOutputs][:starts][:starts] = {
        previousStarts: site_output[:previousStarts],
        currentStarts: site_output[:currentStarts],
        startsSinceLastReturn: site_output[:startsSinceLastReturn],
        previousCompletions: site_output[:previousCompletions],
        currentCompletions: site_output[:currentCompletions],
        completionsSinceLastReturn: site_output[:completionsSinceLastReturn]
      }

      new_site_output[:siteOutputs][:ownership] = {
        laOwned: site_output[:laOwned],
        pslLand: site_output[:pslLand]
      }

      new_site_output[:siteOutputs][:percentages] = {
        brownfieldPercent: site_output[:brownfieldPercent],
        leaseholdPercent: site_output[:leaseholdPercent],
        smePercent: site_output[:smePercent],
        mmcPercent: site_output[:mmcPercent]
      }

      new_site_output
    end

  end

  def convert_mr_review_tab
    return if @return[:reviewAndAssurance].nil?
    @converted_return[:reviewAndAssurance] = {}
    @converted_return[:reviewAndAssurance][:meetingDetails] = {
      date: @return[:reviewAndAssurance][:date],
      meetingHeld: @return[:reviewAndAssurance][:meetingHeld]
    }
    @converted_return[:reviewAndAssurance][:attendance] = @return[:reviewAndAssurance][:attendance]
    @converted_return[:reviewAndAssurance][:meetingsAttended] = @return[:reviewAndAssurance][:meetingsAttended]

    unless @return[:reviewAndAssurance][:infrastructureDeliveries].nil?
      @converted_return[:reviewAndAssurance][:infrastructureDelivery] = @return[:reviewAndAssurance][:infrastructureDeliveries].map do |delivery|
        {
          infrastructureDesc: delivery[:infrastructureDesc],
          reviewDetails: {
            details: delivery[:details],
            riskRating: delivery[:riskRating]
          }
        }
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

    unless @return[:reviewAndAssurance][:assuranceReview].nil?
      @converted_return[:reviewAndAssurance][:summaryOfMeeting] = @return[:reviewAndAssurance][:assuranceReview][:summaryOfMeeting]
      unless @return[:reviewAndAssurance][:assuranceReview][:overallRAGRating].nil?
        @converted_return[:reviewAndAssurance][:overallRAGRating] = @return[:reviewAndAssurance][:assuranceReview][:overallRAGRating]
      end

      @converted_return[:reviewAndAssurance][:overallCommentary] = @return[:reviewAndAssurance][:assuranceReview][:overallCommentary]
      unless @return[:reviewAndAssurance][:assuranceReview][:riskAssessmentSpend].nil?
        @converted_return[:reviewAndAssurance][:riskAssessmentSpend] = @return[:reviewAndAssurance][:assuranceReview][:riskAssessmentSpend]
      end

      unless @return[:reviewAndAssurance][:assuranceReview][:riskAssessmentOutputs].nil?
        @converted_return[:reviewAndAssurance][:riskAssessmentOutputs] = @return[:reviewAndAssurance][:assuranceReview][:riskAssessmentOutputs]
      end
      unless @return[:reviewAndAssurance][:assuranceReview][:raisedIssues].nil?
        @converted_return[:reviewAndAssurance][:raisedIssues] = @return[:reviewAndAssurance][:assuranceReview][:raisedIssues]
      end

      unless @return[:reviewAndAssurance][:assuranceReview][:moreRegularMonitoring].nil?
        @converted_return[:reviewAndAssurance][:recommendForRegularMonitoring] = @return[:reviewAndAssurance][:assuranceReview][:moreRegularMonitoring]
      end

      @converted_return[:reviewAndAssurance][:commentary] = @return[:reviewAndAssurance][:assuranceReview][:commentary]
    end
  end

  def convert_hif_recovery_tab
    return if @return[:hifRecovery].nil?

    @converted_return[:hifRecovery] = @return[:hifRecovery]
  end
end
