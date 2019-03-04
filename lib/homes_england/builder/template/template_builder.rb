# frozen_string_literal: true

class HomesEngland::Builder::Template::TemplateBuilder
  def build_template(type:)
    if type == 'hif'
      HomesEngland::Builder::Template::Templates::HIFTemplate.create
    elsif type == 'ac'
      HomesEngland::Builder::Template::Templates::ACTemplate.create
    elsif type == 'ff'
      File.open("#{__dir__}/templates/ff_template.json") { |file| file.read}
    end
  end
end
