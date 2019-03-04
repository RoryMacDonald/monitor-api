# frozen_string_literal: true

class UI::UseCase::GetBaseClaim
  def initialize(project_gateway:, claim_gateway:)
    @project_gateway = project_gateway
    @claim_gateway = claim_gateway
  end

  def execute(project_id:)
    type = @project_gateway.find_by(id: project_id).type
    schema = @claim_gateway.find_by(type: type).schema

    {
      base_claim: {
        project_id: project_id,
        schema: schema,
        data: {}
      }
    }
  end
end