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

    builder.add_section(section_name: :summary, file_name: 'summary.json')
    builder.add_section(section_name: :infrastructures, file_name: 'infrastructures.json')
    builder.add_section(section_name: :planning, file_name: 'planning.json')
    builder.add_section(section_name: :landOwnership, file_name: 'land_ownership.json')
    builder.add_section(section_name: :procurement, file_name: 'procurement.json')
    builder.add_section(section_name: :demolitionRemediation, file_name: "demolition_and_remediation.json")
    builder.add_section(section_name: :risks, file_name: "risks.json")
    builder.add_section(section_name: :hifGrantExpenditure, file_name: "grant_expenditure.json")

    builder.build
  end
end
