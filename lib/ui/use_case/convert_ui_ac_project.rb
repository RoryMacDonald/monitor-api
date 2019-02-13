# frozen_string_literal: true

class UI::UseCase::ConvertUIACProject
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
    @converted_project[:milestones] = {} 
    unless @project_data[:milestones][:dates].nil?
      unless @project_data[:milestones][:dates][:surveysAndDueDiligence].nil?
        @converted_project[:milestones][:surveysAndDueDiligence] = {
          commencementOfDueDiligence: @project_data[:milestones][:dates][:surveysAndDueDiligence][:commencementOfDueDiligence]
        }
        unless @project_data[:milestones][:dates][:surveysAndDueDiligence][:completionOfSurveysHolder].nil?
          @converted_project[:milestones][:surveysAndDueDiligence][:completionOfSurveys] =  @project_data[:milestones][:dates][:surveysAndDueDiligence][:completionOfSurveysHolder][:completionOfSurveys]
        end
      end

      unless @project_data[:milestones][:dates][:procurementProvision].nil?
        @converted_project[:milestones][:procurementProvision] = {
          procurementOfWorksCommencementDate: @project_data[:milestones][:dates][:procurementProvision][:procurementOfWorksCommencementDate]
        }
        unless @project_data[:milestones][:dates][:procurementProvision][:provisionOfDetailedWorksHolder].nil?
          @converted_project[:milestones][:procurementProvision][:provisionOfDetailedWorks] = @project_data[:milestones][:dates][:procurementProvision][:provisionOfDetailedWorksHolder][:provisionOfDetailedWorks]
        end
      end

      unless @project_data[:milestones][:dates][:worksDate].nil?
        @converted_project[:milestones][:worksDate] = {}

        unless @project_data[:milestones][:dates][:worksDate][:commencementDateHolder].nil?
          @converted_project[:milestones][:worksDate][:commencementDate] = @project_data[:milestones][:dates][:worksDate][:commencementDateHolder][:commencementDate]
        end

        unless @project_data[:milestones][:dates][:worksDate][:completionDateHolder].nil?
          @converted_project[:milestones][:worksDate][:completionDate] = @project_data[:milestones][:dates][:worksDate][:completionDateHolder][:completionDate]
        end
      end

      unless @project_data[:milestones][:dates][:outlinePlanning].nil?
        @converted_project[:milestones][:outlinePlanning] = {
          outlinePlanningGrantedDate: @project_data[:milestones][:dates][:outlinePlanning][:outlinePlanningGrantedDate]
        }

        unless @project_data[:milestones][:dates][:outlinePlanning][:reservedMatterPermissionGrantedDateHolder].nil?
          @converted_project[:milestones][:outlinePlanning][:reservedMatterPermissionGrantedDate] = @project_data[:milestones][:dates][:outlinePlanning][:reservedMatterPermissionGrantedDateHolder][:reservedMatterPermissionGrantedDate]
        end
      end

      unless @project_data[:milestones][:dates][:marketingCommenced].nil?
        @converted_project[:milestones][:marketingCommenced] = @project_data[:milestones][:dates][:marketingCommenced]
      end

      unless @project_data[:milestones][:dates][:contractSigned].nil?
        @converted_project[:milestones][:contractSigned] = {}

        unless @project_data[:milestones][:dates][:contractSigned][:conditionalContractSignedHolder].nil?
          @converted_project[:milestones][:contractSigned][:conditionalContractSigned] = @project_data[:milestones][:dates][:contractSigned][:conditionalContractSignedHolder][:conditionalContractSigned]
        end

        unless @project_data[:milestones][:dates][:contractSigned][:unconditionalContractSignedHolder].nil?
          @converted_project[:milestones][:contractSigned][:unconditionalContractSigned] = @project_data[:milestones][:dates][:contractSigned][:unconditionalContractSignedHolder][:unconditionalContractSigned]
        end
      end

      unless @project_data[:milestones][:dates][:workDates].nil?
        @converted_project[:milestones][:workDates] = {}

        unless @project_data[:milestones][:dates][:workDates][:startOnSiteDateHolder].nil?
          @converted_project[:milestones][:workDates][:startOnSiteDate] = @project_data[:milestones][:dates][:workDates][:startOnSiteDateHolder][:startOnSiteDate]
        end
        unless @project_data[:milestones][:dates][:workDates][:startOnFirstUnitDateHolder].nil?
          @converted_project[:milestones][:workDates][:startOnFirstUnitDate] = @project_data[:milestones][:dates][:workDates][:startOnFirstUnitDateHolder][:startOnFirstUnitDate]
        end
      end

      unless @project_data[:milestones][:dates][:completionDates].nil?
        @converted_project[:milestones][:completionDates] = {
          projectCompletionDate: @project_data[:milestones][:dates][:completionDates][:projectCompletionDate]
        }

        unless @project_data[:milestones][:dates][:completionDates][:completionOfFinalUnitDateHolder].nil?
          @converted_project[:milestones][:completionDates][:completionOfFinalUnitDate] = @project_data[:milestones][:dates][:completionDates][:completionOfFinalUnitDateHolder][:completionOfFinalUnitDate]
        end
      end

      unless @project_data[:milestones][:dates][:customMileStones].nil?
        @converted_project[:milestones][:customMileStones] = @project_data[:milestones][:dates][:customMileStones]
      end
    end
  end

  def convert_outputs
    return if @project_data[:outputs].nil?
    @converted_project[:outputs] = @project_data[:outputs]
  end
end