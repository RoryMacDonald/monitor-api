# frozen_string_literal: true

class LocalAuthority::Gateway::InMemoryClaimTemplate
  def initialize(hif_claims_schema:, ac_claims_schema:)
    @hif_claims_schema = hif_claims_schema
    @ac_claims_schema = ac_claims_schema
  end

  def find_by(type:)
    return @hif_claims_schema.execute if type == 'hif'
    return @ac_claims_schema.execute if type == 'ac'
    nil
  end
end