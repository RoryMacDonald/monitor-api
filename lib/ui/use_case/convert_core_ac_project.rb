# frozen_string_literal: true

class UI::UseCase::ConvertCoreACProject
  def execute(project_data:)
    @project_data = project_data
    @converted_project = {}

    convert_summary
    convert_conditions
    convert_financials
    convert_milestones
    convert_outputs

    @converted_project
  end

  private

  def convert_summary
    return if @project_data[:summary].nil?
    @converted_project[:summary] = @project_data[:summary]
  end

  def convert_conditions
    return if @project_data[:conditions].nil?
    @converted_project[:conditions] = @project_data[:conditions]
  end

  def convert_financials
    return if @project_data[:financials].nil?
    @converted_project[:financials] = @project_data[:financials]
  end

  def convert_milestones
    return if @project_data[:milestones].nil?
    @converted_project[:milestones] = {
      dates: {}
    } 
    
    unless @project_data[:milestones][:surveysAndDueDiligence].nil?
      @converted_project[:milestones][:dates][:surveysAndDueDiligence] = {
        commencementOfDueDiligence: @project_data[:milestones][:surveysAndDueDiligence][:commencementOfDueDiligence]
      }

      @converted_project[:milestones][:dates][:surveysAndDueDiligence][:completionOfSurveysHolder] = {
        completionOfSurveys: @project_data[:milestones][:surveysAndDueDiligence][:completionOfSurveys]
      } 
    end

    unless @project_data[:milestones][:procurementProvision].nil?
      @converted_project[:milestones][:dates][:procurementProvision] = {
        procurementOfWorksCommencementDate: @project_data[:milestones][:procurementProvision][:procurementOfWorksCommencementDate],
        provisionOfDetailedWorksHolder: {
          provisionOfDetailedWorks: @project_data[:milestones][:procurementProvision][:provisionOfDetailedWorks]
        }
      }
    end

    unless @project_data[:milestones][:worksDate].nil?
      @converted_project[:milestones][:dates][:worksDate] = {
        commencementDateHolder: {
          commencementDate: @project_data[:milestones][:worksDate][:commencementDate]
        },
        completionDateHolder: {
          completionDate: @project_data[:milestones][:worksDate][:completionDate]
        }
      }
    end

    unless @project_data[:milestones][:outlinePlanning].nil?
      @converted_project[:milestones][:dates][:outlinePlanning] = {
        outlinePlanningGrantedDate: @project_data[:milestones][:outlinePlanning][:outlinePlanningGrantedDate],
        reservedMatterPermissionGrantedDateHolder: {
          reservedMatterPermissionGrantedDate: @project_data[:milestones][:outlinePlanning][:reservedMatterPermissionGrantedDate]
        }
      }
    end

    unless @project_data[:milestones][:marketingCommenced].nil?
      @converted_project[:milestones][:dates][:marketingCommenced] = @project_data[:milestones][:marketingCommenced]
    end

    unless @project_data[:milestones][:contractSigned].nil?
      @converted_project[:milestones][:dates][:contractSigned] = {
        conditionalContractSignedHolder: {
          conditionalContractSigned: @project_data[:milestones][:contractSigned][:conditionalContractSigned]
        },
        unconditionalContractSignedHolder: {
          unconditionalContractSigned: @project_data[:milestones][:contractSigned][:unconditionalContractSigned]
        }
      }
    end

    unless @project_data[:milestones][:workDates].nil?
      @converted_project[:milestones][:dates][:workDates] = {
        startOnSiteDateHolder: {
          startOnSiteDate: @project_data[:milestones][:workDates][:startOnSiteDate]
        },
        startOnFirstUnitDateHolder: {
          startOnFirstUnitDate: @project_data[:milestones][:workDates][:startOnFirstUnitDate]
        }
      }
    end

    unless @project_data[:milestones][:completionDates].nil?
      @converted_project[:milestones][:dates][:completionDates] = {
        completionOfFinalUnitDateHolder: {
          completionOfFinalUnitDate: @project_data[:milestones][:completionDates][:completionOfFinalUnitDate]
        },
        projectCompletionDate: @project_data[:milestones][:completionDates][:projectCompletionDate]
      }
    end

    unless @project_data[:milestones][:customMileStones].nil?
      @converted_project[:milestones][:dates][:customMileStones] = @project_data[:milestones][:customMileStones]
    end
  end

  def convert_outputs
    return if @project_data[:outputs].nil?
    @converted_project[:outputs] = @project_data[:outputs]
  end
end