
class Common::UseCase::SanitiseData
  def execute(data:)
    compact_data(data)
  end
  
  private

  def data_present?(value)
    return false if value.nil?
    return true unless value.is_a?(String)
    return !value.strip.empty?
  end
  
  def compact_data(data)
    if data.is_a?(Hash)
      data.keep_if { |key, value| data_present?(value) }
      data.each_value { |child| compact_data(child) }
    elsif data.is_a?(Array)
      data.each_with_index do |item, index|
        data.delete_at(index) unless data_present?(item)
        compact_data(item)
      end
    end
  end
end
