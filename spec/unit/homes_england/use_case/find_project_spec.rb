# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::FindProject do
  let(:project_gateway) { double(find_by: project) }
  let(:use_case) { described_class.new(project_gateway: project_gateway) }
  let(:response) { use_case.execute(id: id) }

  before { response }

  context 'example one' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |proj|
        proj.name = 'Dog project'
        proj.type = 'hif'
        proj.data = { dogs: 'woof' }
        proj.status = 'Draft'
        proj.bid_id = 'HIF/MV/155'
        proj.timestamp = 0
      end
    end
    let(:id) { 1 }

    it 'finds the project on the gateway' do
      expect(project_gateway).to have_received(:find_by).with(id: 1)
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
  end

  context 'example two' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |proj|
        proj.name = 'meow cats'
        proj.type = 'abc'
        proj.data = { cats: 'meow' }
        proj.status = 'Submitted'
        proj.timestamp = 456
        proj.bid_id = 'AC/MV/256'
      end
    end
    let(:id) { 5 }

    it 'returns a hash containing the projects name' do
      expect(response[:name]).to eq('meow cats')
    end

    it 'finds the project on the gateway' do
      expect(project_gateway).to have_received(:find_by).with(id: 5)
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
  end
end
