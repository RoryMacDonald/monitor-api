class HomesEngland::Gateway::InMemoryMonthlyCatchupTemplate
  def execute(type:)
    get_template('hif.json') if type == 'hif'
  end

  def get_template(schema)
    @template = Common::Domain::Template.new

    File.open("#{__dir__}/schemas/monthly_catchup/#{schema}", 'r') do |f|
      @template.schema = Common::PreprocessJSON.parse(f.read)
    end

    @template
  end
end
