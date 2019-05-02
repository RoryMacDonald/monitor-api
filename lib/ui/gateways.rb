# frozen_string_literal: true

class UI::Gateways
  def self.register(builder)
    builder.define_gateway :ui_project_schema do
      UI::Gateway::InMemoryProjectSchema.new
    end

    builder.define_gateway :ui_return_schema do
      UI::Gateway::InMemoryReturnSchema.new
    end

    builder.define_gateway :ui_new_project do
      UI::Gateway::InMemoryNewProject.new
    end

    builder.define_gateway :ui_claim_schema do
      UI::Gateway::InMemoryClaimSchema.new
    end

    builder.define_gateway :ui_monthly_catchup_schema do
      UI::Gateway::InMemoryMonthlyCatchupSchemaGateway.new
    end
  end
end
