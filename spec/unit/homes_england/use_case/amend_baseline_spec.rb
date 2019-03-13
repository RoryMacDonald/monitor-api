describe HomesEngland::UseCase::AmendBaseline do
  let(:project_gateway) do
    spy(
      update: nil,
      find_by: found_project
    )
  end

  let(:baseline_gateway) do 
    spy(
      versions_for: [last_baseline]
    )
  end
  
  let(:usecase) do
    described_class.new(
      project_gateway: project_gateway,
      baseline_gateway: baseline_gateway
    )
  end

  context 'example 1' do
    let(:found_project) do
      HomesEngland::Domain::Project.new.tap do |project|
        project.name = 'My HIF Project'
        project.type = 'hif'
        project.status = 'Submitted'
        project.bid_id = 'HIF/MV/1'
        project.data = {}
      end
    end

    let(:last_baseline) do
      HomesEngland::Domain::Baseline.new.tap do |base|
        base.status = 'Submitted'
        base.timestamp = timestamp
        base.version = 1
      end
    end

    context 'correct timestamp' do
      let(:timestamp) do
        time_now = Time.now
        Timecop.freeze(time_now)
        time_now.to_i - 3
      end

      it 'gets the last submitted baseline' do
        usecase.execute(project_id: 1, data: {}, timestamp: timestamp)
        expect(baseline_gateway).to have_received(:versions_for).with(project_id: 1)
      end
      
      it 'create a new baseline with the new data and incremented version' do
        usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(baseline_gateway).to have_received(:create) do |baseline|
          expect(baseline.data).to eq(myData: 'myValue')
          expect(baseline.version).to eq(2)
          expect(baseline.status).to eq('Draft')
        end
      end

      it 'calls the create method on the gateway with a new timestamp' do
        usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(baseline_gateway).to have_received(:create) do |baseline|
          expect(baseline.timestamp).to be > timestamp
        end
      end
      
      it 'should return success and no errors' do
        result = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(result[:success]).to eq(true)
        expect(result[:errors]).to eq([])
      end

      it 'should return the new timestamp' do
        result = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(result[:timestamp]).to be > timestamp
      end
    end

    context 'incorrect timestamp' do 
      let(:timestamp) { 345 }

      it 'returns unsuccessful' do 
        response = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: 250)
        expect(response[:success]).to eq(false)
      end

      it 'doesnt call update on the project gateway' do 
        usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: 250)
        expect(baseline_gateway).not_to have_received(:create)        
      end

      it 'returns an incorrect timestamp error' do 
        response = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: 250)
        expect(response[:errors]).to eq([:incorrect_timestamp])
      end

      it 'returns the unaltered timestamp ' do 
        response = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: 250)
        expect(response[:timestamp]).to eq(250)
      end
    end
  end

  context 'example 2' do
    let(:found_project) do
      HomesEngland::Domain::Project.new.tap do |project|
        project.name = 'My AC Project'
        project.type = 'ac'
        project.status = 'Submitted'
        project.timestamp = 22226666
        project.version = 7
        project.bid_id = 'HIF/MV/1'
        project.data = { newData: 'differentValues' }
      end
    end

    let(:last_baseline) do
      HomesEngland::Domain::Baseline.new.tap do |base|
        base.status = 'Submitted'
        base.timestamp = 22226666
        base.version = 7
      end
    end

    let(:timestamp) do
      time_now = Time.now
      Timecop.freeze(time_now)
      time_now.to_i - 3
    end
      
    it 'calls the find method on the gateway' do
      usecase.execute(project_id: 3, data: {}, timestamp: timestamp)
      expect(baseline_gateway).to have_received(:versions_for).with(project_id: 3)
    end

    it 'calls the update method on the gateway' do
      usecase.execute(project_id: 3, data: { newData: 'differentValues' }, timestamp: timestamp)
      expect(baseline_gateway).to have_received(:create) do |baseline|
        expect(baseline.data).to eq(newData: 'differentValues')
        expect(baseline.version).to eq(8)
        
        expect(baseline.status).to eq('Draft')
      end
    end

    context 'incorrect timestamp' do 
      let(:timestamp) { 512 }

      it 'returns unsuccessful' do 
        response = usecase.execute(project_id: 3, data: { newData: 'differentValues' }, timestamp: 256)
        expect(response[:success]).to eq(false)
      end
    end
  end
end
