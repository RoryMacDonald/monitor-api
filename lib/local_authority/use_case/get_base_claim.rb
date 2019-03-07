# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseClaim
  def initialize(claim_gateway:, project_gateway:, populate_return_template:)
    @claim_gateway = claim_gateway
    @project_gateway = project_gateway
    @populate_return_template = populate_return_template
  end

  def execute(project_id:)
    @project_gateway.find_by(id: project_id)
    @claim_gateway.find_by(type: 'hif')
  end
end
