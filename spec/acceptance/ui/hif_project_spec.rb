# frozen_string_literal: true

require_relative '../shared_context/dependency_factory'

describe 'Interacting with a HIF Project from the UI' do
  include_context 'dependency factory'

  let(:environment_before) { ENV }
  let(:pcs_domain) { 'http://meow.cat' }

  let(:project_id) { create_project }

  let(:baseline_data_ui) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:empty_baseline_data) do
    File.open("#{__dir__}/../../fixtures/hif_empty_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:populated_baseline_data) do
    File.open("#{__dir__}/../../fixtures/hif_populated_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:updated_ui_baseline_data) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  before do
    environment_before
    ENV['PCS'] = 'yes'
    ENV['PCS_DOMAIN'] = pcs_domain
    ENV['PCS_SECRET'] = 'aoeaoe'
  end

  after do
    ENV['PCS'] = environment_before['PCS']
    ENV['PCS_DOMAIN'] = environment_before['PCS_DOMAIN']
    ENV['PCS_SECRET'] = environment_before['PCS_SECRET']
  end

  def create_project
    get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: baseline_data_ui,
      bid_id: 'HIF/MV/111'
    )[:id]
  end

  def create_empty_project
    get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: empty_baseline_data,
      bid_id: 'HIF/MV/15'
    )[:id]
  end

  def get_project(id, bid_id)
    stub_request(:get, "#{pcs_domain}/pcs-api/v1/Projects/#{bid_id}/actuals")
      .to_return(status: 200, body: '{}', headers: {})

    stub_request(:get, "#{pcs_domain}/pcs-api/v1/Projects/#{bid_id}").to_return(
      status: 200,
      body: {
        ProjectManager: 'Michael',
        Sponsor: 'MSPC'
      }.to_json
    )
    get_use_case(:ui_get_project).execute(id: id)
  end

  context 'Creating the project' do
    let(:empty_project_id) { create_empty_project }

    def given_baseline_data
      baseline_data_ui
    end

    def given_no_baseline_data
      empty_baseline_data
    end

    def when_the_user_creates_a_project
      project_id
    end

    def when_the_user_creates_an_empty_project
      empty_project_id
    end

    def then_the_new_project_can_be_viewed
      created_project = get_project(project_id, 'HIF%252FMV%252F111')
      expect(created_project[:type]).to eq('hif')
      expect(created_project[:name]).to eq('Cat Infrastructures')
      expect(created_project[:bid_id]).to eq('HIF/MV/111')
      expect(created_project[:data]).to eq(baseline_data_ui)
    end

    def then_the_new_empty_project_can_be_viewed
      created_project = get_project(empty_project_id, 'HIF%252FMV%252F15')
      expect(created_project[:type]).to eq('hif')
      expect(created_project[:name]).to eq('Cat Infrastructures')
      expect(created_project[:bid_id]).to eq('HIF/MV/15')
      expect(created_project[:data]).to eq(populated_baseline_data)
    end

    it 'Can create an empty project successfully' do
      given_no_baseline_data
      when_the_user_creates_an_empty_project
      then_the_new_empty_project_can_be_viewed
    end

    it 'Can create a project successfully' do
      given_baseline_data
      when_the_user_creates_a_project
      then_the_new_project_can_be_viewed
    end
  end

  context 'Updating a project' do
    def given_a_project_with_baseline
      project_id
    end

    def when_the_user_updates_the_project
      get_use_case(:ui_update_project).execute(id: project_id, data: updated_ui_baseline_data, type: 'hif', timestamp: 2)
    end

    def then_the_updated_project_can_be_viewed
      updated_project = get_project(project_id, 'HIF%252FMV%252F111')
      expect(updated_project[:data]).to eq(updated_ui_baseline_data)
    end

    it 'Can update an existing project successfully' do
      given_a_project_with_baseline
      when_the_user_updates_the_project
      then_the_updated_project_can_be_viewed
    end
  end
end
