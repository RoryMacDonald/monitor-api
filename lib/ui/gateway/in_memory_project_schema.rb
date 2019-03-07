# frozen_string_literal: true

class UI::Gateway::InMemoryProjectSchema
  def find_by(type:)
    return create_template('hif_project.json') if type == 'hif'
    return create_template('ac_project.json') if type == 'ac'

    ff_template if type == 'ff'
  end

  private

  def create_template(schema)
    template = Common::Domain::Template.new

    File.open("#{__dir__}/schemas/#{schema}", 'r') do |f|
      template.schema = JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
    template
  end

  def ff_template
    builder = UI::Builder::Template.new(path: "#{__dir__}/schemas/ff/project", title: 'FF Project')

    builder.add_shared_data(file_name: 'shared_data.json')

    builder.add_section(section_name: :summary, file_name: 'summary.json') unless ENV['FF_SUMMARY_TAB'].nil?
    builder.add_section(section_name: :infrastructures, file_name: 'infrastructures.json') unless ENV['FF_INFRAS_TAB'].nil?
    builder.add_section(section_name: :planning, file_name: 'planning.json') unless ENV['FF_PLANNING_TAB'].nil?
    builder.add_section(section_name: :landOwnership, file_name: 'land_ownership.json') unless ENV['FF_LAND_OWNERSHIP_TAB'].nil?
    builder.add_section(section_name: :procurement, file_name: 'procurement.json') unless ENV['FF_PROCUREMENT_TAB'].nil?
    builder.add_section(section_name: :demolitionRemediation, file_name: 'demolition_and_remediation.json') unless ENV['FF_DEMOLITION_TAB'].nil?
    builder.add_section(section_name: :milestones, file_name: 'milestones.json') unless ENV['FF_MILESTONES_TAB'].nil?
    builder.add_section(section_name: :risks, file_name: 'risks.json') unless ENV['FF_RISKS_TAB'].nil?
    builder.add_section(section_name: :hifGrantExpenditure, file_name: 'grant_expenditure.json') unless ENV['FF_GRANT_EXPENDITURE_TAB'].nil?
    builder.add_section(section_name: :infraFundingPackage, file_name: "infrastructure_funding_package.json") unless ENV['FF_FUNDING_PACKAGE_TAB'].nil?
    builder.add_section(section_name: :hifRecovery, file_name: "hif_recovery.json") unless ENV['FF_RECOVERY_TAB'].nil?
    builder.add_section(section_name: :widerScheme, file_name: 'wider_scheme.json') unless ENV['FF_WIDER_SCHEME_TAB'].nil?
    builder.add_section(section_name: :outputs, file_name: 'outputs.json') unless ENV['FF_OUTPUTS_TAB'].nil?

    builder.build
  end
end
