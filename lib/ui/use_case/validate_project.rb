# frozen_string_literal: true

class UI::UseCase::ValidateProject
  def initialize(project_schema_gateway:, get_project_template_path_titles:)
    @project_schema_gateway = project_schema_gateway
    @get_project_template_path_titles = get_project_template_path_titles
  end

  def execute(type:, project_data:)
    schema = @project_schema_gateway.find_by(type: type)

    project_data = compact_data(project_data)
    
    invalid_paths = schema.invalid_paths(project_data)
    invalid_pretty_paths = invalid_paths.map do |path|
      @get_project_template_path_titles.execute(path: path, schema: schema.schema)[:path_titles]
    end

    {
      valid: invalid_paths.empty?,
      invalid_paths: invalid_paths,
      pretty_invalid_paths: invalid_pretty_paths
    }
  end

  private 
  
  def compact_data(data)
    if data.is_a?(Hash)
      data.keep_if {|key, value| !value.nil?}
      data.each_value { |child| compact_data(child) }
    elsif data.is_a?(Array)
      data.each { |item| compact_data(item)}
    end
  end
end
