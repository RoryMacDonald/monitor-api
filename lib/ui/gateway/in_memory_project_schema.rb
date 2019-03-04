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

    builder.add_section(name: 'summary', file_name: 'summary.json')
    builder.add_section(name: 'infrastructures', file_name: 'infrastructures.json')
    builder.add_section(name: 'planning', file_name: 'planning.json')
    builder.add_section(name: 'landOwnership', file_name: 'land_ownership.json')
    builder.add_section(name: 'procurement', file_name: 'procurement.json')

    builder.build
  end
end
