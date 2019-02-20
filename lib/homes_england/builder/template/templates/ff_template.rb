class HomesEngland::Builder::Template::Templates::FFTemplate
  def self.create
    ff_template = Common::Domain::Template.new
    ff_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'FF Project',
      type: 'object',
      properties: {
        infrastructures: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              sectionA: {
                type: 'object',
                properties: {
                  information: {
                    type: 'string'
                  }
                }
              }
            }
          }
        }
      }
    }

    ff_template
  end
end
