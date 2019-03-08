# frozen_string_literal: true

class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(find_path_data:, get_schema_copy_paths:, get_return_template_path_types:)
    @find_path_data = find_path_data
    @get_schema_copy_paths = get_schema_copy_paths
    @get_return_template_path_types = get_return_template_path_types
  end

  def execute(schema:, data:)
    populated_return = {}

    paths = @get_schema_copy_paths.execute(schema: schema)[:paths]
    paths.each do |copy_path_pair|
      populated_return = copy_data(
        copy_path_pair,
        data,
        schema,
        populated_return
      )
    end

    { populated_data: populated_return }
  end

  private

  def copy_data(copy_path_pair, data, schema, return_data)
    path_types = @get_return_template_path_types.execute(schema: schema, path: copy_path_pair[:to])[:path_types].drop(1)

    found_data = @find_path_data.execute(
      data: data,
      path: copy_path_pair[:from]
    )[:found]

    descend_hash_and_bury(
      return_data,
      copy_path_pair[:to],
      path_types,
      found_data
    )
  end

  def descend_array(hash, path, path_types, value)
    return unless value.class == Array
    hash[path.first] = descend_array_and_bury(
      hash[path.first],
      path.drop(1),
      path_types.drop(1),
      value
    )
  end

  def descend_hash(hash, path, path_types, value)
    hash[path.first] = descend_hash_and_bury(
      hash[path.first],
      path.drop(1),
      path_types.drop(1),
      value
    )
  end

  # Burying is when we descend through a hash and look for our path where we place
  # our value if path_types contains arrays descend_array and bury will split up
  # the array of values that will exist
  def descend_hash_and_bury(hash, path, path_types, value)
    if last_node?(path)
      value
    else
      if node_is_array?(path_types)
        ensure_array_exists(hash, path)
        descend_array(hash, path, path_types, value)
      elsif node_is_object?(path_types)
        ensure_hash_exists(hash, path)
        descend_hash(hash, path, path_types, value)
      end
      hash
    end
  end

  def descend_array_and_bury(array, path, path_types, value)
    array = [] if array.nil?
    value.zip(array).map do |to_put, hash|
      hash = {} if hash.nil?
      descend_hash_and_bury(hash, path, path_types, to_put)
    end
  end

  def last_node?(path)
    path.empty?
  end

  def node_is_array?(path_types)
    path_types.first == :array
  end

  def node_is_object?(path_types)
    path_types.first == :object
  end

  def ensure_hash_exists(hash, path)
    hash[path.first] = {} if hash[path.first].nil?
  end

  def ensure_array_exists(hash, path)
    hash[path.first] = [] if hash[path.first].nil?
  end
end
