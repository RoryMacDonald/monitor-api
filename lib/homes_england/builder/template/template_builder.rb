# frozen_string_literal: true

class HomesEngland::Builder::Template::TemplateBuilder
  def build_template(type:)
    if type == 'hif'
      HomesEngland::Builder::Template::Templates::HIFTemplate.create
    elsif type == 'ac'
      HomesEngland::Builder::Template::Templates::ACTemplate.create
    elsif type == 'ff'
      ff_template = Common::Domain::Template.new
      File.open("#{__dir__}/templates/ff_template.json") do |f|
        ff_template.schema = JSON.parse(f.read, symbolize_names: true)
      end
      ff_template
    end
  end
end
