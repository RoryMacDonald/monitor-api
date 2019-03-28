class Common::PreprocessJSON
  def self.parse(json_text)
    preprocessed_json = format_newline_values(json_text)
    parsed_json = JSON.parse(preprocessed_json, symbolize_names: true)
  end

  def self.format_newline_values(json_text)
    json_text.gsub(/:\s*"[^"]*"/) do |capture|
      capture.gsub("\n","\\n")
    end
  end
end
