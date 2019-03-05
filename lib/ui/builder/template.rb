class UI::Builder::Template
  def initialize(path:, title:)
    @path = path
    @schema = {
      '$schema' => 'http://json-schema.org/draft-07/schema',
      title: title,
      type: 'object',
      sharedData: [],
      properties: {}
    }
  end

  def add_section(section_name:, file_name:)
    File.open("#{@path}/#{file_name}") do |f|
      @schema[:properties][section_name] = JSON.parse(f.read, symbolize_names: true)
    end
  end

  def add_shared_data(file_name:)
    File.open("#{@path}/#{file_name}") do |f|
      @schema[:sharedData] = JSON.parse(f.read, symbolize_names: true)
    end
  end

  def build
    Common::Domain::Template.new.tap do |t|
      t.schema = @schema
    end
  end
end
