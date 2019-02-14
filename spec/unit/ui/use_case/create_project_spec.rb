# frozen_string_literal: true

describe UI::UseCase::CreateProject do
  context 'Example one' do
    let(:create_project_spy) { spy(execute: { id: 1 }) }
    let(:convert_ui_project_spy) { spy(execute: { cattos: 'purr' }) }
    let(:new_project_gateway_spy) { spy(find_by: {data: 'new'})}
    let(:use_case) do
      described_class.new(
        create_project: create_project_spy,
        convert_ui_project: convert_ui_project_spy,
        new_project_gateway: new_project_gateway_spy
      )
    end
    let(:response) do
      use_case.execute(type: 'hif', name: 'Cats', baseline: { Cats: 'purr' }, bid_id: 'HIF/MV/25')
    end

    before do
      response
    end

    it 'Calls execute on the create project usecase' do
      expect(create_project_spy).to have_received(:execute)
    end

    it 'Calls execute on the create project usecase with the project type' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(type: 'hif'))
      )
    end

    it 'Calls execute on the create project usecase with the project name' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(name: 'Cats'))
      )
    end

    it 'Calls execute on the create project usecase with the project bid id' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(bid_id: 'HIF/MV/25'))
      )
    end

    it 'Returns the id from create project' do
      expect(response).to eq(id: 1)
    end

    it 'Calls execute on the convert use case' do
      expect(convert_ui_project_spy).to have_received(:execute)
    end

    it 'Passes the project data to the converter' do
      expect(convert_ui_project_spy).to have_received(:execute).with(
        project_data: { Cats: 'purr' }, type: 'hif'
      )
    end

    it 'Creates the project with the converted data' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(baseline: { cattos: 'purr' }))
      )
    end

    context 'no baseline data' do
      let(:blank_project_response) { use_case.execute(type: 'hif', name: 'Cats', baseline: nil) }
      before { blank_project_response }

      it 'calls the new project gateway with type' do
          expect(new_project_gateway_spy).to have_received(:find_by).with(type: 'hif')
      end
      
      it 'Ccreates the project with this baseline' do
        expect(create_project_spy).to(
          have_received(:execute).with(hash_including(baseline: {data: 'new'}))
        )
      end
    end
  end

  context 'Example two' do
    let(:create_project_spy) { spy(execute: { id: 5 }) }
    let(:convert_ui_project_spy) { spy(execute: { dogs: 'woof' }) }
    let(:new_project_gateway_spy) { spy(find_by: { newdata: '2' })}
    let(:use_case) do
      described_class.new(
        create_project: create_project_spy,
        convert_ui_project: convert_ui_project_spy,
        new_project_gateway: new_project_gateway_spy
      )
    end
    let(:response) do
      use_case.execute(type: 'laac', name: 'Dogs', baseline: { doggos: 'woof' }, bid_id: 'HIF/MV/75')
    end

    before do
      response
    end

    it 'Calls execute on the create project usecase' do
      expect(create_project_spy).to have_received(:execute)
    end

    it 'Calls execute on the create project usecase with the project type' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(type: 'laac'))
      )
    end

    it 'Calls execute on the create project usecase with the project name' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(name: 'Dogs'))
      )
    end

    it 'Calls execute on the create project usecase with the baseline' do
      expect(create_project_spy).to(
        have_received(:execute).with(
          hash_including(
            baseline: { dogs: 'woof' }
          )
        )
      )
    end

    it 'Returns the id from create project' do
      expect(response).to eq(id: 5)
    end

    it 'Calls execute on the convert use case' do
      expect(convert_ui_project_spy).to have_received(:execute)
    end

    it 'Passes the project data to the converter' do
      expect(convert_ui_project_spy).to have_received(:execute).with(
        project_data: { doggos: 'woof' }, type: 'laac'
      )
    end

    it 'Calls execute on the create project usecase with the project bid id' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(bid_id: 'HIF/MV/75'))
      )
    end

    it 'Creates the project with the converted data' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(baseline: { dogs: 'woof' }))
      )
    end

    context 'no baseline data' do
      let(:blank_project_response) { use_case.execute(type: 'ac', name: 'Cats', baseline: nil) }
      before { blank_project_response }
      
      it 'calls the new project gateway with type' do
          expect(new_project_gateway_spy).to have_received(:find_by).with(type: 'ac')
      end
      
      it 'returns this baselin' do
        expect(create_project_spy).to(
          have_received(:execute).with(hash_including(baseline: {newdata: '2'}))
        ) 
      end
    end
  end
end
