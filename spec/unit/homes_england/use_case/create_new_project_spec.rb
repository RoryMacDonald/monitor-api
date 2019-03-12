# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::CreateNewProject do
  let(:project_gateway) { double(create: project_id) }
  let(:baseline_gateway) { spy }
  let(:use_case) do
    described_class.new(
      project_gateway: project_gateway,
      baseline_gateway: baseline_gateway
    )
  end
  let(:response) { use_case.execute(name: name, type: type, baseline: baseline, bid_id: bid_id) }

  before do
    response
  end

  context 'example one' do
    let(:name) { 'Cat HIF' }
    let(:project_id) { 0 }
    let(:type) { 'hif' }
    let(:baseline) { { key: 'value' } }
    let(:status) { '' }
    let(:bid_id) { 'HIF/MV/121' }


    it 'creates the project with populated data' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.name).to eq('Cat HIF')
        expect(project.type).to eq('hif')
        expect(project.bid_id).to eq('HIF/MV/121')
      end
    end

    it 'create a baseline with version 1' do
      expect(baseline_gateway).to have_received(:create) do |baseline|
        expect(baseline.project_id).to eq(0)
        expect(baseline.data).to eq(key: 'value')
        expect(baseline.version).to eq(1)
      end
    end

    it 'returns the id from the project gateway' do
      expect(response).to eq(id: 0)
    end

    it 'gives the project a status of draft' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.status).to eq('Draft')
      end
    end
  end

  context 'example two' do
    let(:name) { 'Other cat project' }
    let(:project_id) { 42 }
    let(:type) { 'cats' }
    let(:baseline) { { cat: 'meow' } }
    let(:status) { '' }
    let(:bid_id) { 'HIF/MV/111' }

    it 'creates the project' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.name).to eq('Other cat project')
        expect(project.type).to eq('cats')
        expect(project.bid_id).to eq('HIF/MV/111')
      end
    end

    it 'create a baseline with version 1' do
      expect(baseline_gateway).to have_received(:create) do |baseline|
        expect(baseline.project_id).to eq(42)
        expect(baseline.data).to eq(cat: 'meow')
        expect(baseline.version).to eq(1)
      end
    end

    it 'returns the id from the gateway' do
      expect(response).to eq(id: 42)
    end

    it 'gives the project a status of draft' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.status).to eq('Draft')
      end
    end
  end
end
