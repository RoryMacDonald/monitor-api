# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseClaim
  def initialize(claim_gateway:, project_gateway:, populate_return_template:, get_claims:)
    @claim_gateway = claim_gateway
    @project_gateway = project_gateway
    @populate_return_template = populate_return_template
    @get_claims = get_claims
  end

  def execute(project_id:)
    project = @project_gateway.find_by(id: project_id)
    claim_schema = @claim_gateway.find_by(type: project.type).schema
    claims = @get_claims.execute(project_id: project_id)[:claims]
    
    claim_data = find_last_claim(claims)
    data = populate_claim(claim_schema, project.data, claim_data)

    {
      base_claim: {
        id: project_id,
        data: data[:populated_data]
      }
    }
  end

  private

  def find_last_claim(claims)
    return if claims.empty?
    submitted_claims = claims.select { |claim| claim[:status] === 'Submitted' }
    return if submitted_claims.empty?
    submitted_claims.last[:data]
  end

  def populate_claim(schema, baseline_data, claim_data)
    if claim_data.nil?
      @populate_return_template.execute(
        schema: schema,
        data: { baseline_data: baseline_data }
      )
    else
      @populate_return_template.execute(
        schema: schema,
        data: { baseline_data: baseline_data, claim_data: claim_data }
      )
    end
  end
end
