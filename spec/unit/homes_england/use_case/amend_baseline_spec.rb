describe HomesEngland::UseCase::AmendBaseline do
  let(:project_gateway) do
    spy(
      update: nil,
      find_by: found_project
    )
  end
  
  let(:usecase) { described_class.new(project_gateway: project_gateway)}

  context 'example 1' do
    let(:found_project) do
      HomesEngland::Domain::Project.new.tap do |project|
        project.name = 'My HIF Project'
        project.type = 'hif'
        project.status = 'Submitted'
        project.timestamp = timestamp
        project.version = 1
        project.bid_id = 'HIF/MV/1'
        project.data = {}
      end
    end
    context 'correct timestamp' do
      let(:timestamp) do
        time_now = Time.now
        Timecop.freeze(time_now)
        time_now.to_i - 3
      end

      it 'calls the find method on the gateway' do
        usecase.execute(project_id: 1, data: {}, timestamp: timestamp)
        expect(project_gateway).to have_received(:find_by).with(id: 1)
      end
      
      it 'calls the update method on the gateway with the new data and incremented version' do
        usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(project_gateway).to have_received(:update) do |project|
          expect(project[:project].data).to eq(myData: 'myValue')
          expect(project[:project].version).to eq(2)

          expect(project[:project].name).to eq('My HIF Project')
          expect(project[:project].type).to eq('hif')
          expect(project[:project].status).to eq('Submitted')
          expect(project[:project].bid_id).to eq('HIF/MV/1')
        end
      end

      it 'calls the update method on the gateway with a new timestamp' do
        usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(project_gateway).to have_received(:update) do |project|
          expect(project[:project].timestamp).to be > timestamp
        end
      end
      
      it 'should return success' do
        result = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: timestamp)
        expect(result[:success]).to eq(true)
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
        expect(project_gateway).not_to have_received(:update)        
      end

      it 'returns an incorrect timestamp error' do 
        response = usecase.execute(project_id: 1, data: { myData: 'myValue' }, timestamp: 250)
        expect(response[:errors]).to eq([:incorrect_timestamp])
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

    let(:timestamp) do
      time_now = Time.now
      Timecop.freeze(time_now)
      time_now.to_i - 3
    end
      
    it 'calls the find method on the gateway' do
      usecase.execute(project_id: 3, data: {}, timestamp: timestamp)
      expect(project_gateway).to have_received(:find_by).with(id: 3)
    end

    it 'calls the update method on the gateway' do
      usecase.execute(project_id: 3, data: { newData: 'differentValues' }, timestamp: timestamp)
      expect(project_gateway).to have_received(:update) do |project|
        expect(project[:project].data).to eq(newData: 'differentValues')
        expect(project[:project].version).to eq(8)
        
        expect(project[:project].name).to eq('My AC Project')
        expect(project[:project].type).to eq('ac')
        expect(project[:project].status).to eq('Submitted')
        expect(project[:project].bid_id).to eq('HIF/MV/1')
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
