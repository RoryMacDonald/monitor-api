class HomesEngland::Gateways
  def self.register(builder)
    builder.define_gateway :project do
      HomesEngland::Gateway::SequelProject.new(database: builder.database)
    end

    builder.define_gateway :baseline do
      HomesEngland::Gateway::SequelBaseline.new(database: builder.database)
    end

    builder.define_gateway :template do
      HomesEngland::Gateway::InMemoryTemplate.new(
        template_builder: builder.get_gateway(:template_builder)
      )
    end

    builder.define_gateway :template_builder do
      HomesEngland::Builder::Template::TemplateBuilder.new
    end

    builder.define_gateway :pcs do
      HomesEngland::Gateway::Pcs.new
    end

    builder.define_gateway :monthly_catchup do
      HomesEngland::Gateway::SequelMonthlyCatchup.new(database: builder.database)
    end
  end
end
