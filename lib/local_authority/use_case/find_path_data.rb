class LocalAuthority::UseCase::FindPathData
  def execute(data:, path:)
    if path.first == :return_or_baseline
      found = search_return_or_baseline(data, path)
    else
      found = search_hash(data, path)
    end

    if !(found.nil? || found.empty?)
      { found: found }
    else
      {}
    end
  end

  private

  def search_return_or_baseline(data, path)
    found_baseline_data = search_hash(data, get_baseline_path(path))
    found_return_data = search_hash(data, get_return_path(path))

    merge_baseline_return_data(found_baseline_data, found_return_data)
  end

  def merge_baseline_return_data(found_baseline_data, found_return_data)
    if found_baseline_data.class == Array && found_return_data.class == Array
      found_baseline_data.zip(found_return_data).map do |baseline_value, return_value|
        merge_baseline_return_data(baseline_value, return_value)
      end
    else
      prefer_return_value(found_baseline_data, found_return_data)
    end
  end

  def get_baseline_path(path)
    if path[1].first == :baseline_data
      path[1]
    else
      path[2]
    end
  end

  def get_return_path(path)
    if path[1].first == :return_data
      path[1]
    else
      path[2]
    end
  end

  def prefer_return_value(baseline_value, return_value)
    if return_value.nil?
      baseline_value
    else
      return_value
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
