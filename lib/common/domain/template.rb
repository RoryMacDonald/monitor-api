# frozen_string_literal: true

require 'json_schema'
class Common::Domain::Template
  attr_accessor :layout, :schema

  def invalid_paths(project_data)
    schema = parse_json_schema(@schema)
    get_invalid_paths(schema, project_data) || []
  end

  private

  def parse_json(schema)
    JSON.parse(schema.to_json)
  end

  def parse_json_schema(schema)
    JsonSchema.parse!(parse_json(schema))
  end

  def validate_json_schema(schema, project_data)
    schema.validate!(parse_json(project_data))
  end

  def get_invalid_paths(schema, project_data)
    validate_json_schema(schema, project_data)
    nil
  rescue JsonSchema::AggregateError => aggregated_errors
    all_error_paths = []
    get_supported_errors(aggregated_errors).each do |error|
      error_path = error.path.drop(1)
      if error.type == :required_failed
        get_required_failed_node_names(error).each  do |error|
          full_path = Array.new(error_path).push(error)
          all_error_paths.push(symbolize_path(full_path))
        end
      elsif error.type = :one_of_failed
        get_dependency_failed_path_names(error, project_data).each do |path|
          all_error_paths.push(symbolize_path(path))
        end
      end
    end
    all_error_paths
  end

  def unselected_enum_option(error)
    error.each do |suberror|
      return true if suberror.to_s.include? "is not a member of"
    end

    false
  end

  def get_dependency_failed_path_names(error, project_data)
    paths = []
    error.sub_errors.each do |error|
      next if unselected_enum_option(error)

      error.each do |message|
        next if message.data.nil?
        next if message_is_array_index?(message)
        next unless message.data.kind_of?(Array)

        path =  message.path
        path.shift

        message.data.each do |node|
          full_path = Array.new(path)
          paths.push(full_path.push(node))
        end
      end
    end
    paths
  end

  def get_required_failed_node_names(error)
    error.data
  end

  def get_supported_errors(aggregated_errors)
    aggregated_errors.errors.select do |error|
      %i[required_failed one_of_failed].include? error.type
    end
  end

  def symbolize_path(path)
    path.map do |node|
      if node.class == String
        node.to_sym
      else
        node
      end
    end
  end

  private

  def message_is_array_index?(message)
    message.data.is_a? Integer
  end
end
