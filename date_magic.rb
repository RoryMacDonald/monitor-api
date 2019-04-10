require_relative './lib/loader'
require 'date'

def findDates(tree, path = [], paths = [])
  if tree.instance_of? Hash
    tree.each do |key, value|
      if key == :format && value == "date"
        paths.push(path)
      else
        findDates(value, path + [key], paths)
      end
    end
    paths
  elsif tree.instance_of? Array
    tree.each do |item|
      findDates(item, path, paths)
    end
  end
end

def print_dates(data, path)
  return if data.nil?
  if path[0] == :properties
    return parse_data(data, path.drop(1))
  end
  if path[0] == :items
    return data&.map do |d|
      parse_data(d, path.drop(1))
    end
  end
  if path.empty?
    p "#{data}"
  else
    data[path[0].to_sym] = parse_data(data[path[0].to_sym], path.drop(1))
    data
  end
end

def parse_data(data, path)
  return if data.nil?
  if path[0] == :properties
    return parse_data(data, path.drop(1))
  end
  if path[0] == :items
    return data&.map do |d|
      parse_data(d, path.drop(1))
    end
  end
  if path.empty?
    if data.length >= 8 && data.length <= 10
      if data == "0000-00-00"
        p "WARN: Weird 0 date"
      else
        begin
          parsed = Date.parse(data)
            # p "#{data} -> #{parsed}"
        rescue ArgumentError
          p "ERR: #{data}"
        end
      end
    else
      p "ERR: #{data}"
    end

    data
  else
    data[path[0].to_sym] = parse_data(data[path[0].to_sym], path.drop(1))
    data
  end
end

f = Dependencies.dependency_factory

projects = f.database[:projects].select(:id, :type).order_by(:id).all
get_project = f.get_use_case(:ui_get_project)

projects.each do |project|
  found_project = get_project.execute(id: project[:id])
  paths = findDates(found_project[:schema])
  # p "*** PROJECT ID: #{project[:id]}"
  # p "*** PROJECT TYPE: #{project[:type]}"
  # p "*** PROJECT STATUS: #{found_project[:status]}"

  data = found_project[:data]

  paths.each do |path|
    data = parse_data(data, path)
  end
end
