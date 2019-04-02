  describe HomesEngland::UseCase::UpdateProjectAdmin do 
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.timestamp = timestamp
      end
    end
    let(:project_gateway_spy) { spy(find_by: project) }
    let(:usecase) { described_class.new(project_gateway: project_gateway_spy) }
    
    describe 'correct timestamp' do 
      let(:response) { usecase.execute(project_id: project_id, data: data, timestamp: timestamp)}
  
      before { response }
      after { Timecop.return }

      context 'example one' do       
        let(:timestamp) do
          time_now = Time.now
          Timecop.freeze(time_now)
          time_now = time_now.to_i - 3
        end
        
        let(:data) do
          {
            admin: {
              name: 'la',
              email: 'la@la.com',
              link: 'he'
            }
          }
        end

        let(:project_id) { 1 }

        it 'calls the update method on the project gateway with the project id' do
          expect(project_gateway_spy).to have_received(:update).with(
            hash_including(id: 1)
          )
        end

        it 'calls the update method on the project gateway with the data' do
          expect(project_gateway_spy).to have_received(:update).with(
            hash_including(data: data)
          )
        end

        it 'calls the update method on the project gateway with the current timestamp' do
          expect(project_gateway_spy).to have_received(:update).with(
            hash_including(timestamp: timestamp + 3)
          )
        end

        it 'returns successly' do
          expect(response[:successful]).to eq(true)
        end

        it 'returns the new timestamp' do
          expect(response[:timestamp]).to eq(timestamp + 3)
        end

        it 'returns no errors' do
          expect(response[:errors]).to eq([])
        end
      end

      context 'example two' do   
        let(:timestamp) { 0 }

        let(:data) do
          {
            admin2: {
              name2: 'la',
              email2: 'la@la.com',
              link2: 'he'
            }
          }
        end

        let(:project_id) { 5 }

        it 'calls the update method on the project gateway with the project id' do
          expect(project_gateway_spy).to have_received(:update).with(
            hash_including(id: 5)
          )
        end

        it 'calls the update method on the project gateway with the data' do
          expect(project_gateway_spy).to have_received(:update).with(
            hash_including(data: data)
          )
        end
      end
    end

    describe 'incorrect timestamp' do
      let(:timestamp) do
        time_now = Time.now
        Timecop.freeze(time_now)
        time_now = time_now.to_i - 3
      end

      let(:data) do
        {
          admin: {
            name: 'la',
            email: 'la@la.com',
            link: 'he'
          }
        }
      end
      let(:project_id) { 1 }
      let(:response) { usecase.execute(project_id: project_id, data: data, timestamp: timestamp + 100)}
  
      before { response }
      
      it 'calls the find by method on the project gateway with the project id' do
        expect(project_gateway_spy).to have_received(:find_by).with(
          hash_including(id: 1)
        )
      end

      it 'doesnt call the project gateway' do
        expect(project_gateway_spy).not_to have_received(:update)
      end

      it 'returns unsuccessful' do
        expect(response[:successful]).to eq(false)
      end

      it 'returns an incorrect timestamp error' do 
        expect(response[:errors]).to eq([:incorrect_timestamp])
      end
    end
  end