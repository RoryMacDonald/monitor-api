describe HomesEngland::UseCase::GetBaselines do
  let(:baseline_gateway) { spy(versions_for: baseline_versions) }
  let(:usecase) { described_class.new(baseline_gateway: baseline_gateway) }
  let(:response) { usecase.execute(project_id: project_id) }
  before { response }

  context 'Example 1' do
    let(:project_id) { 23 }
    let(:baseline_versions) do 
      [
        HomesEngland::Domain::Baseline.new.tap do |base|
          base.id = 2
          base.data = { data: 'financial data' }
          base.version = 1
          base.status = 'Submitted'
        end,
        HomesEngland::Domain::Baseline.new.tap do |base|
          base.id = 45
          base.data = { new_data: 'cat data' }
          base.version = 2
          base.status = 'Draft'
        end
      ]
    end

    it 'calls the baseline gateway' do
      expect(baseline_gateway).to have_received(:versions_for).with(project_id: 23)
    end

    it 'returns the data from the gateway as a hash' do
      expect(response[:baselines][0][:data]).to eq(data: 'financial data')
      expect(response[:baselines][1][:data]).to eq(new_data: 'cat data')
    end

    it 'returns the versions of all baselines' do
      expect(response[:baselines][0][:version]).to eq(1)
      expect(response[:baselines][1][:version]).to eq(2)
    end

    it 'returns the statuses  of all baselines' do
      expect(response[:baselines][0][:status]).to eq('Submitted')
      expect(response[:baselines][1][:status]).to eq('Draft')
    end

    it 'returns the ids of all baselines' do
      expect(response[:baselines][0][:id]).to eq(2)
      expect(response[:baselines][1][:id]).to eq(45)
    end
  end

  context 'Example 2' do
    let(:project_id) { 44 }
    let(:baseline_versions) do 
      [
        HomesEngland::Domain::Baseline.new.tap do |base|
          base.id = 3
          base.data = {}
          base.version = 1
          base.status = 'Submitted'
        end,
        HomesEngland::Domain::Baseline.new.tap do |base|
          base.id = 56
          base.data = { old_data: 'dog data' }
          base.version = 2
          base.status = 'Submitted'
        end,
        HomesEngland::Domain::Baseline.new.tap do |base|
          base.id = 123
          base.data = { cats: 'cat cat ' }
          base.version = 3
          base.status = 'Draft'
        end
      ]
    end

    it 'calls the baseline gateway' do
      expect(baseline_gateway).to have_received(:versions_for).with(project_id: 44)
    end

    it 'returns the data from the gateway as a hash' do
      expect(response[:baselines][0][:data]).to eq({})
      expect(response[:baselines][1][:data]).to eq({ old_data: 'dog data' })
      expect(response[:baselines][2][:data]).to eq({ cats: 'cat cat ' })
    end

    it 'returns the versions of all baselines' do
      expect(response[:baselines][0][:version]).to eq(1)
      expect(response[:baselines][1][:version]).to eq(2)
      expect(response[:baselines][2][:version]).to eq(3)
    end

    it 'returns the statuses  of all baselines' do
      expect(response[:baselines][0][:status]).to eq('Submitted')
      expect(response[:baselines][1][:status]).to eq('Submitted')
      expect(response[:baselines][2][:status]).to eq('Draft')
    end

    it 'returns the ids of all baselines' do
      expect(response[:baselines][0][:id]).to eq(3)
      expect(response[:baselines][1][:id]).to eq(56)
      expect(response[:baselines][2][:id]).to eq(123)
    end
  end
end