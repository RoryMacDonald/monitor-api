class LocalAuthority::UseCase::FindPathData
  def execute(data:, path:)
    path = choose_path(data, path) if path[0] == :return_or_baseline 

    found = search_hash(data, path)
    if !(found.nil? || found.empty?)
      { found: found }
    else
      {}
    end
  end

  private

  def choose_path(data, path)
    if data.has_key?(:return_data)
      path[2]
    else
      path[1]
    end
  end

  def search_array(data, path)
    data.map do |x|
      search_hash(x[path.first], path.drop(1))
    end
  end

  def search_hash(data, path)
    if path.empty?
      data
    elsif data.class == Hash
      search_hash(data[path.first], path.drop(1))
    elsif data.class == Array
      search_array(data, path)
    end
  end
end
