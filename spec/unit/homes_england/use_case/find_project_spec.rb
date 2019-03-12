# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::FindProject do
  let(:project_gateway) { double(find_by: project) }
  let(:baseline_gateway) do
    spy(
      versions_for: baselines
    )
  end
  let(:use_case) do
    described_class.new(
      project_gateway: project_gateway,
      baseline_gateway: baseline_gateway
    )
  end
  let(:response) { use_case.execute(id: id) }

  before { response }

  context 'example one' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |proj|
        proj.name = 'Dog project'
        proj.type = 'hif'
        proj.data = { dogs: 'woof' }
        proj.bid_id = 'HIF/MV/155'
      end
    end

    let(:baseline_data) do
      HomesEngland::Domain::Baseline.new.tap do |base|
        base.data = { dogs: 'woof' }
        base.status = 'Draft'
        base.timestamp = 0
        base.version = 1
      end
    end

    let(:baselines)  { [baseline_data] }

    let(:id) { 1 }

    it 'finds the project on the gateway' do
      expect(project_gateway).to have_received(:find_by).with(id: 1)
    end

    it 'get the baseline data from the baseline gateway' do
      expect(baseline_gateway).to have_received(:versions_for).with(project_id: 1)
    end

    it 'returns a hash containing the projects name' do
      expect(response[:name]).to eq('Dog project')
    end

    it 'returns a hash containing the projects type' do
      expect(response[:type]).to eq('hif')
    end

    it 'returns a hash containing the bid id' do
      expect(response[:bid_id]).to eq('HIF/MV/155')
    end

    it 'returns a hash containing the projects data' do
      expect(response[:data]).to eq(dogs: 'woof')
    end

    it 'returns a hash containing the projects status' do
      expect(response[:status]).to eq('Draft')
    end

    it 'returns a hash containing the projects timestamp' do
      expect(response[:timestamp]).to eq(0)
    end

    it 'returns a hash containing the version number' do
      expect(response[:version]).to eq(1)
    end
  end

  context 'example two' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |proj|
        proj.name = 'meow cats'
        proj.type = 'abc'
        proj.status = 'Submitted'
        proj.bid_id = 'AC/MV/256'
      end
    end
    let(:baseline_data_1) do
      HomesEngland::Domain::Baseline.new.tap do |base|
        base.data = { cats: 'meow' }
        base.status = 'Submitted'
        base.timestamp = 456
        base.version = 1
      end
    end
    let(:baseline_data_2) do
      HomesEngland::Domain::Baseline.new.tap do |base|
        base.data = { cats: 'meow' }
        base.status = 'Submitted'
        base.timestamp = 456
        base.version = 2
      end
    end


    let(:baseline_data_3) do
      HomesEngland::Domain::Baseline.new.tap do |base|
        base.data = { cats: 'meow' }
        base.status = 'Submitted'
        base.timestamp = 456
        base.version = 3
      end
    end

    let(:baselines) do 
      [baseline_data_1, baseline_data_2, baseline_data_3]
    end


    let(:id) { 5 }

    it 'returns a hash containing the projects name' do
      expect(response[:name]).to eq('meow cats')
    end

    it 'finds the project on the gateway' do
      expect(project_gateway).to have_received(:find_by).with(id: 5)
    end

    it 'get the baseline data from the baseline gateway' do
      expect(baseline_gateway).to have_received(:versions_for).with(project_id: 5)
    end

    it 'returns a hash containing the projects type' do
      expect(response[:type]).to eq('abc')
    end

    it 'returns a hash containing the bid id' do
      expect(response[:bid_id]).to eq('AC/MV/256')
    end

    it 'returns a hash containing the projects data' do
      expect(response[:data]).to eq(cats: 'meow')
    end

    it 'returns a hash containing the projects status' do
      expect(response[:status]).to eq('Submitted')
    end

    it 'returns a hash containing the projects timestamp' do
      expect(response[:timestamp]).to eq(456)
    end

    it 'returns a hash containing the version number' do
      expect(response[:version]).to eq(3)
    end
  end
end
