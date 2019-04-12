require_relative '../shared_context/dependency_factory'

describe "An LA-AC Project through the UI", focus: true do
  include_context "dependency factory"
  let(:fixture_directory) { "#{__dir__}/../../fixtures" }

  let(:valid_project_baseline) do
    File.open("#{fixture_directory}/ac_valid_ui_baseline_data.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:created_project_id) do
    get_use_case(:ui_create_project).execute(
      name: 'a project', type: 'ac', baseline: nil, bid_id: 'HIF/MV/16'
    )[:id]
  end

  let(:created_project) do
    get_use_case(:ui_get_project).execute(id: created_project_id)
  end

  before do
    created_project_id
  end

  it 'Allows you to create an AC project' do
    expect(created_project[:name]).to eq('a project')
    expect(created_project[:type]).to eq('ac')
  end

  it 'Returns invalid for empty projects' do
    project_data = created_project[:data]

    expect_project_data_to_be_invalid(project_data)
  end

  it 'Returns valid for filled out projects' do
    expect_project_data_to_be_valid(valid_project_baseline)
  end

  private

  def expect_project_data_to_be_invalid(project_data)
    validation_response = get_use_case(:ui_validate_project).execute(
      type: 'ac',
      project_data: project_data
    )

    expect(validation_response[:valid]).to eq(false)
  end

  def expect_project_data_to_be_valid(project_data)
    validation_response = get_use_case(:ui_validate_project).execute(
      type: 'ac',
      project_data: project_data
    )

    expect(validation_response[:valid]).to eq(true)
  end

end
