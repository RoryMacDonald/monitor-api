# frozen_string_literal: true

class UI::UseCase::GetBaseClaim
  def initialize(project_gateway:, claim_gateway:, get_base_claim:)
    @project_gateway = project_gateway
    @claim_gateway = claim_gateway
    @get_base_claim = get_base_claim
  end

  def execute(project_id:)
    type = @project_gateway.execute(id: project_id)[:type]
    schema = @claim_gateway.find_by(type: type).schema
    data = @get_base_claim.execute(project_id: project_id)[:base_claim][:data]

    {
      base_claim: {
        project_id: project_id,
        schema: schema,
        data: data
      }
    }
  end
end