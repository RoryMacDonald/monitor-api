class UI::UseCase::ValidateClaim
  def initialize(claim_template:, get_claim_path_titles:)
    @claim_template = claim_template
    @get_claim_path_titles = get_claim_path_titles
  end

  def execute(type:, claim_data:)
    template = @claim_template.find_by(type: type)
    schema = template.schema
    
    invalid_paths = template.invalid_paths(claim_data)
    invalid_pretty_paths = invalid_paths.map do |path|
      @get_claim_path_titles.execute(path: path, schema: schema)[:path_titles]
    end

    {
      valid: invalid_paths.empty?,
      invalid_paths: invalid_paths,
      invalid_pretty_paths: invalid_pretty_paths
    }
  end
end
