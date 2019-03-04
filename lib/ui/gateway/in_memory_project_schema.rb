# frozen_string_literal: true

class UI::Gateway::InMemoryProjectSchema
  def find_by(type:)
    if type == 'hif'
      schema = 'hif_project.json'
    elsif type == 'ac'
      schema = 'ac_project.json'
    elsif type == 'ff'
      schema = 'ff_project.json'
    else
      return nil
    end
    create_template(schema, type)
  end

  private

  def create_template(schema, type)
    template = Common::Domain::Template.new

    if type == 'ff'
      template.schema = ff_schema

      return template
    end

    File.open("#{__dir__}/schemas/#{schema}", 'r') do |f|
      template.schema = JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
    template
  end

  def ff_schema
    path = "#{__dir__}/schemas/ff/project"

    ff_schema = {
      '$schema' => 'http://json-schema.org/draft-07/schema',
      title: 'FF Project',
      type: 'object',
      properties: {}
    }

    File.open("#{path}/summary.json", 'r') do |file|
      ff_schema[:properties][:summary] = JSON.parse(
        file.read, symbolize_names: true
      )
    end

    File.open("#{path}/infrastructures.json", 'r') do |file|
      ff_schema[:properties][:infrastructures] = JSON.parse(
        file.read, symbolize_names: true
      )
    end

    File.open("#{path}/planning.json", 'r') do |file|
      ff_schema[:properties][:planning] = JSON.parse(
        file.read, symbolize_names: true
      )
    end

    File.open("#{path}/land_ownership.json", 'r') do |file|
      ff_schema[:properties][:landOwnership] = JSON.parse(
        file.read, symbolize_names: true
      )
    end

    File.open("#{path}/procurement.json", 'r') do |file|
      ff_schema[:properties][:procurement] = JSON.parse(
        file.read, symbolize_names: true
      )
    end

    ff_schema
  end
end
