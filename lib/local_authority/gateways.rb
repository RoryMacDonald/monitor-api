class LocalAuthority::Gateways
  def self.register(builder)
    builder.define_gateway :return_gateway do
      LocalAuthority::Gateway::SequelReturn.new(database: builder.database)
    end

    builder.define_gateway :return_update_gateway do
      LocalAuthority::Gateway::SequelReturnUpdate.new(
        database: builder.database
      )
    end

    builder.define_gateway :hif_return_template do
      LocalAuthority::Gateway::HIFReturnsSchemaTemplate.new
    end

    builder.define_gateway :hif_claim_template do
      LocalAuthority::Gateway::HIFClaimSchemaTemplate.new
    end

    builder.define_gateway :ac_return_template do
      LocalAuthority::Gateway::ACReturnsSchemaTemplate.new
    end

    builder.define_gateway :ac_claim_template do
      LocalAuthority::Gateway::ACClaimSchemaTemplate.new
    end

    builder.define_gateway :return_template do
      LocalAuthority::Gateway::InMemoryReturnTemplate.new(
        hif_returns_schema: builder.get_gateway(:hif_return_template),
        ac_returns_schema: builder.get_gateway(:ac_return_template)
      )
    end

    builder.define_gateway :claim_template do
      LocalAuthority::Gateway::InMemoryClaimTemplate.new(
        hif_claims_schema: builder.get_gateway(:hif_claim_template),
        ac_claims_schema: builder.get_gateway(:ac_claim_template)
      )
    end

    builder.define_gateway :users do
      LocalAuthority::Gateway::SequelUsers.new(
        database: builder.database
      )
    end

    builder.define_gateway :access_token do
      LocalAuthority::Gateway::InMemoryAccessTokenGateway.new
    end

    builder.define_gateway :notification do
      LocalAuthority::Gateway::GovEmailNotificationGateway.new
    end

    builder.define_gateway :api_key do
      LocalAuthority::Gateway::InMemoryAPIKeyGateway.new
    end

    builder.define_gateway :claim do
      LocalAuthority::Gateway::SequelClaim.new(
        database: builder.database
      )
    end
  end
end
