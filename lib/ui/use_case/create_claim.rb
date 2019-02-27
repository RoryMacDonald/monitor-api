class UI::UseCase::CreateClaim
  def initialize(find_project:, create_claim_core:, convert_ui_claim:)
    @find_project = find_project
    @convert_ui_claim = convert_ui_claim
    @create_claim_core = create_claim_core
  end

  def execute(project_id:, claim_data:)
    type = @find_project.execute(id: project_id)[:type]
    core_claim_data = @convert_ui_claim.execute(claim_data: claim_data, type: type)
    claim_id = @create_claim_core.execute(
      project_id: project_id,
      claim_data: core_claim_data
    )[:claim_id]

    { claim_id: claim_id }
  end
end
