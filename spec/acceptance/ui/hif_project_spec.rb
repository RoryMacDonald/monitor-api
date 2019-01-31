# frozen_string_literal: true

require_relative '../shared_context/dependency_factory'

describe 'Interacting with a HIF Project from the UI' do
  include_context 'dependency factory'

  let(:pcs_url) { 'meow.cat' }

  let(:baseline_data_ui) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/hif_baseline_ui.json").read,
      symbolize_names: true
    )
  end

  let(:empty_baseline_data) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/hif_empty_baseline_ui.json").read,
      symbolize_names: true
    )
  end

  let(:updated_ui_baseline_data) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/hif_baseline_ui.json").read,
      symbolize_names: true
    )
  end

  def create_project
    dependency_factory.get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: baseline_data_ui,
      bid_id: 'HIF/MV/111'
    )[:id]
  end

  def create_empty_project
    dependency_factory.get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: empty_baseline_data,
      bid_id: 'HIF/MV/15'
    )[:id]
  end

  def get_project(id)
    ENV['PCS_URL'] = pcs_url
    stub_request(:get, "http://#{pcs_url}/project/#{id}").to_return(
      status: 200,
      body: {
        ProjectManager: "Michael",
        Sponsor: "MSPC"
      }.to_json
    )

    dependency_factory.get_use_case(:ui_get_project).execute(
      id: id
    )
  end

  context 'Creating the project' do
    it 'Can create the project successfully' do
      project_id = create_project
      created_project = get_project(project_id)

      expect(created_project[:type]).to eq('hif')
      expect(created_project[:name]).to eq('Cat Infrastructures')
      expect(created_project[:bid_id]).to eq('HIF/MV/111')
      expect(created_project[:data]).to eq(baseline_data_ui)
    end

    it 'Can create an empty project successfully' do
      project_id = create_empty_project
      created_project = get_project(project_id)

      expect(created_project[:type]).to eq('hif')
      expect(created_project[:name]).to eq('Cat Infrastructures')
      expect(created_project[:bid_id]).to eq('HIF/MV/15')
      expect(created_project[:data]).to eq(empty_baseline_data)
    end
  end

  context 'Updating a project' do
    it 'Can update a created project successfully' do
      project_id = create_project

      dependency_factory.get_use_case(:ui_update_project).execute(id: project_id, data: updated_ui_baseline_data, type: 'hif', timestamp: 2)

      updated_project = get_project(project_id)

      expect(updated_project[:data]).to eq(updated_ui_baseline_data)
    end
  end
end
