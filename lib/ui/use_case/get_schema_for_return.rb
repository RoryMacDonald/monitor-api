class UI::UseCase::GetSchemaForReturn
  def initialize(get_return:, return_template:)
    @get_return = get_return
    @return_template = return_template
  end

  def execute(return_id:, pcs_key:)
    type = @get_return.execute(id: return_id, pcs_key: pcs_key)[:type]
    schema = @return_template.find_by(type: type).schema
    {
      schema: schema
    }
  end
end
