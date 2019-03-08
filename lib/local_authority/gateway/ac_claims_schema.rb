require 'json'

class LocalAuthority::Gateway::ACClaimSchemaTemplate
  def execute
    @return_template = Common::Domain::Template.new.tap do |p|
      p.schema = {}
    end
  end
end