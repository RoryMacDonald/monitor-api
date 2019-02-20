# frozen_string_literal: true

describe UI::UseCase::GetProject do
  describe 'Example 1' do
    let(:project_schema_gateway_spy) do
      spy(find_by: found_template)
    end
    let(:found_template) do
      Common::Domain::Template.new.tap do |t|
        t.schema = { cat: 'meow' }
      end
    end
    let(:find_project_spy) do
      spy(
        execute: {
          name: 'Big Buildings',
          type: 'hif',
          data: { building1: 'a house' },
          status: 'Draft',
          timestamp: 0,
          bid_id: "HIF/MV/14"
        }
      )
    end
    let(:convert_core_project_spy) { spy(execute: { building2: 'a house' }) }
    let(:use_case) do
      described_class.new(
        find_project: find_project_spy,
        convert_core_project: convert_core_project_spy,
        project_schema_gateway: project_schema_gateway_spy
      )
    end
    let(:response) { use_case.execute(id: 1, pcs_key: 'X.Y.Z') }

    before do
      response
    end

    it 'Calls execute in the find project use case' do
      expect(find_project_spy).to have_received(:execute)
    end

    it 'Passes the ID to the find project usecase' do
      expect(find_project_spy).to have_received(:execute).with(hash_including(project_id: 1))
    end

    it 'Passes the api key to the find project usecase' do
      expect(find_project_spy).to have_received(:execute).with(hash_including(pcs_key: 'X.Y.Z'))
    end

    it 'Finds the schema from the gateway' do
      expect(project_schema_gateway_spy).to have_received(:find_by).with(
        type: 'hif'
      )
    end

    it 'Returns the schema from the gateway' do
      expect(response[:schema]).to eq(cat: 'meow')
    end

    it 'Return the name from find project' do
      expect(response[:name]).to eq('Big Buildings')
    end

    it 'Return the type from find project' do
      expect(response[:type]).to eq('hif')
    end

    it 'Return the status from find project' do
      expect(response[:status]).to eq('Draft')
    end

    it 'Return the bid id from find project' do
      expect(response[:bid_id]).to eq('HIF/MV/14')
    end

    it 'Returns the timestamp from find project' do
      expect(response[:timestamp]).to eq(0)
    end

    it 'Calls execute on the convert core hif project use case' do
      expect(convert_core_project_spy).to have_received(:execute)
    end

    it 'Passes the project data to the converter' do
      expect(convert_core_project_spy).to(
        have_received(:execute).with(
          project_data: { building1: 'a house' }, type: 'hif'
        )
      )
    end

    it 'Returns the converted data from find project' do
      expect(response[:data]).to eq(building2: 'a house')
    end
  end

  describe 'Example 2' do
    let(:project_schema_gateway_spy) do
      spy(find_by: found_template)
    end
    let(:found_template) do
      Common::Domain::Template.new.tap do |t|
        t.schema = { dog: 'woof' }
      end
    end
    let(:find_project_spy) do
      spy(
        execute: {
          name: 'Big ol woof',
          type: 'hif',
          data: { noise: 'bark' },
          status: 'Barking',
          timestamp: 345,
          bid_id: "HIF/MV/155"
        }
      )
    end
    let(:convert_core_project_spy) { spy(execute: { noiseMade: 'bark' }) }
    let(:use_case) do
      described_class.new(
        find_project: find_project_spy,
        convert_core_project: convert_core_project_spy,
        project_schema_gateway: project_schema_gateway_spy
      )
    end
    let(:response) { use_case.execute(id: 5, pcs_key: 'M.R.Y') }

    before do
      response
    end

    it 'Calls execute in the find project use case' do
      expect(find_project_spy).to have_received(:execute)
    end

    it 'Passes the api key to the find project usecase' do
      expect(find_project_spy).to have_received(:execute).with(hash_including(pcs_key: 'M.R.Y'))
    end

    it 'Passes the ID to the find project usecase' do
      expect(find_project_spy).to have_received(:execute).with(hash_including(project_id: 5))
    end

    it 'Finds the schema from the gateway' do
      expect(project_schema_gateway_spy).to have_received(:find_by).with(
        type: 'hif'
      )
    end

    it 'Return the bid id from find project' do
      expect(response[:bid_id]).to eq('HIF/MV/155')
    end

    it 'Returns the schema from the gateway' do
      expect(response[:schema]).to eq(dog: 'woof')
    end

    it 'Return the name from find project' do
      expect(response[:name]).to eq('Big ol woof')
    end

    it 'Return the type from find project' do
      expect(response[:type]).to eq('hif')
    end

    it 'Return the status from find project' do
      expect(response[:status]).to eq('Barking')
    end

    it 'Return the timestamp from find project' do
      expect(response[:timestamp]).to eq(345)
    end

    it 'Calls execute on the convert core hif project use case' do
      expect(convert_core_project_spy).to have_received(:execute)
    end

    it 'Passes the project data to the converter' do
      expect(convert_core_project_spy).to(
        have_received(:execute).with(
          project_data: { noise: 'bark' }, type: 'hif'
        )
      )
    end

    it 'Returns the converted data from find project' do
      expect(response[:data]).to eq(noiseMade: 'bark')
    end
  end
end
