
class LocalAuthority::UseCase::GetSchemaCopyPaths
  def execute(schema:)
    { paths: get_paths(schema) }
  end

  private

  def get_paths(template_schema, current_path = [])
    paths = []
    template_schema[:properties].each do |property, value|
      node_path = current_path + [property]
      if value[:type] == 'object'
        paths += get_paths(value, node_path)
      elsif value[:type] == 'array'
        paths += get_paths(value[:items], node_path)
      end

      unless value[:sourceKey].nil?
        paths << { to: node_path, from: value[:sourceKey] }
      end
    end

    template_schema[:dependencies]&.each do |_property, value|
      value[:oneOf].each do |item|
        paths += get_paths(item, current_path)
      end
    end
    paths
  end
end
