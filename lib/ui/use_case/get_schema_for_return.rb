class UI::UseCase::GetSchemaForReturn
  def initialize(return_template:)
    @return_template = return_template
  end

  def execute(type:)
    schema = @return_template.find_by(type: type).schema
    {
      schema: schema
    }
  end
end
