class UI::Gateway::InMemoryNewProject
  def find_by(type:)
    if type == 'hif'
      create_project('mvf')
    elsif type == 'ac'
      create_project('ac')      
    else
      return nil
    end
  end

  private

  def create_project(type)
    File.open("#{__dir__}/blank_projects/#{type}.json", 'r') do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end
end