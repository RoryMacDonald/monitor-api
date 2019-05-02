class UI::Gateway::InMemoryMonthlyCatchupSchemaGateway
  def find_by(type:)
    return create_template('hif.json', 'hif') if type == 'hif'
  end

  def create_template(schema, type)
    template = Common::Domain::Template.new

    File.open("#{__dir__}/schemas/monthly_catchup/#{schema}", 'r') do |f|
      template.schema = JSON.parse(
        f.read,
        symbolize_names: true
      )
    end

    template
  end
end
