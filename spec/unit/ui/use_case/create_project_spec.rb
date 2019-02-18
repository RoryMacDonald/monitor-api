# frozen_string_literal: true

describe UI::UseCase::CreateProject do
  context 'Example one' do
    let(:create_project_spy) { spy(execute: { id: 1 }) }
    let(:convert_ui_project_spy) { spy(execute: { cattos: 'purr' }) }
    let(:use_case) do
      described_class.new(
        create_project: create_project_spy,
        convert_ui_project: convert_ui_project_spy
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
  end

  context 'Example two' do
    let(:create_project_spy) { spy(execute: { id: 5 }) }
    let(:convert_ui_project_spy) { spy(execute: { dogs: 'woof' }) }
    let(:use_case) do
      described_class.new(
        create_project: create_project_spy,
        convert_ui_project: convert_ui_project_spy
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
  end
end
