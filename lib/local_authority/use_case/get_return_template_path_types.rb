class LocalAuthority::UseCase::GetReturnTemplatePathTypes
  using Common::Refinement::HashHasPath

  def execute(schema:, path:)
    { path_types: schema_types(schema, path) }
  end

  private

  def schema_types(schema, path)
    return [:not_found] if schema.nil?
    return [:object] if path.empty?
    return get_schema_types_from_array(path, schema) if schema[:type] == 'array'
    return get_schema_types_from_object(path, schema) if schema[:type] == 'object'
    [:unsupported_type]
  end

  def get_schema_types_from_array(path, schema)
    acquired_path = [:not_found]
    if array_has_property?(path, schema)
      acquired_path = get_path_types_from_array_properties(path, schema)
    end
    if array_has_item_dependencies?(schema) && path_not_found?(acquired_path)
      acquired_path = get_path_types_from_array_dependencies(path, schema)
    end
    acquired_path
  end

  def get_schema_types_from_object(path, schema)
    acquired_path = [:not_found]

    if object_has_property(path, schema)
      acquired_path = get_path_types_from_object_properties(path, schema)
    end

    if object_has_dependencies(schema) && path_not_found?(acquired_path)
      acquired_path = get_path_types_from_object_dependencies(path, schema)
    end

    [:object] + acquired_path
  end

  def path_not_found?(path)
    path.last == :not_found
  end

  def path_found?(path)
    path.last != :not_found
  end

  def get_path_types_from_array_dependencies(path, schema)
    schema.dig(:items, :dependencies).values.each do |value|
      path_types = get_state_path(value, path)
      return [:array] + path_types if path_found?(path_types)
    end
  end

  def array_has_item_dependencies?(schema)
    schema.hash_has_path?(%i[items dependencies])
  end

  def get_path_types_from_array_properties(path, schema)
    [:array] + schema_types(schema.dig(:items, :properties, path.first), path.drop(1))
  end

  def array_has_property?(path, schema)
    schema.hash_has_path?([:items, :properties, path.first])
  end

  def get_path_types_from_object_dependencies(path, schema)
    schema[:dependencies].values.each do |value|
      path_types = get_state_path(value, path)
      return path_types if path_found?(path_types)
    end
  end

  def get_path_types_from_object_properties(path, schema)
    schema_types(schema[:properties][path.first], path.drop(1))
  end

  def object_has_dependencies(schema)
    schema.hash_has_path?([:dependencies])
  end

  def object_has_property(path, schema)
    schema.hash_has_path?([:properties, path.first])
  end

  def get_state_path(schema, path)
    schema[:oneOf].each do |value|
      path_types = get_path_from_object(value, path)
      return path_types if path_found?(path_types)
    end
    [:not_found]
  end

  def get_path_from_object(value, path)
    property = value.dig(:properties, path.first)
    schema_types(property, path.drop(1))
  end
end
