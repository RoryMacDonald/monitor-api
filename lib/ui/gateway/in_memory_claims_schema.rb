class UI::Gateway::InMemoryClaimSchema
  def find_by(type:)
    if type == 'hif'
      return create_template('hif.json', type)
    elsif type == 'ac'
      return create_template('ac.json', type)
    end
  end

  def create_template(schema, type)
    @template = Common::Domain::Template.new

    File.open("#{__dir__}/schemas/claims/#{schema}", 'r') do |f|
      @template.schema = JSON.parse(
        f.read,
        symbolize_names: true
      )
    end

    @template
  end
end
