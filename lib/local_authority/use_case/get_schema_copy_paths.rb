
class LocalAuthority::UseCase::GetSchemaCopyPaths
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:)
    { paths: get_paths(@template_gateway.find_by(type: type).schema) }
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
        paths << { to: node_path, from: value[:sourceKey].map(&:to_sym) }
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
