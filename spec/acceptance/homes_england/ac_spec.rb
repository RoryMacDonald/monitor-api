require_relative '../shared_context/dependency_factory'

describe "An AC Project through the UI" do
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

  context do
    def when_i_create_an_ac_project
      created_project_id
    end

    def then_i_can_get_the_baseline
      expect(created_project[:name]).to eq('a project')
      expect(created_project[:type]).to eq('ac')
    end

    it 'Allows you to create an AC baseline' do
      when_i_create_an_ac_project
      then_i_can_get_the_baseline
    end
  end

  context do
    def given_an_ac_baseline_with_invalid_data
      created_project_id
    end

    def then_the_baseline_does_not_validate
      validation_response = get_use_case(:ui_validate_project).execute(
        type: 'ac',
        project_data: created_project[:data]
      )

      expect(validation_response[:valid]).to eq(false)
    end

    it 'Empty baselines do not pass validation' do
      given_an_ac_baseline_with_invalid_data
      then_the_baseline_does_not_validate
    end
  end

  context do
    def given_an_ac_baseline
      created_project_id
    end

    def when_i_update_the_baseline_with_valid_data
      get_use_case(:ui_update_project).execute(id: created_project_id, data: valid_project_baseline, timestamp: 0, type: 'ac')
    end

    def then_the_baseline_validates
      baseline_data = get_use_case(:ui_get_project).execute(id: created_project_id)

      validation_response = get_use_case(:ui_validate_project).execute(
        type: 'ac',
        project_data: baseline_data
      )

      expect(validation_response[:valid]).to eq(true)
    end

    it 'Filled out projects pass validation' do
      given_an_ac_baseline
      when_i_update_the_baseline_with_valid_data
      then_the_baseline_validates
    end
  end
end
