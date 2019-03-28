# frozen_string_literal: true

describe UI::UseCase::UpdateBaseline do
  context 'Example one' do
    let(:update_baseline_spy) { spy(execute: { successful: true, errors: [], timestamp: 4 }) }
    let(:convert_ui_project_spy) { spy(execute: { catto: 'meow' }) }
    let(:use_case) do
      described_class.new(
        update_baseline: update_baseline_spy,
        convert_ui_project: convert_ui_project_spy
      )
    end
    let(:response) do
      use_case.execute(id: 7, type: 'hif', data: { cat: 'meow' }, timestamp: 5)
    end

    before { response }

    it 'Calls execute on the update project usecase' do
      expect(update_baseline_spy).to have_received(:execute)
    end

    it 'Passes the update project use case the project ID' do
      expect(update_baseline_spy).to(
        have_received(:execute).with(hash_including(project_id: 7))
      )
    end

    it 'Returns successful if successful' do
      expect(response[:successful]).to eq(true)
    end

    it 'Returns the errors array' do
      expect(response[:errors]).to eq([])
    end

    it 'Returns the timestamp' do
      expect(response[:timestamp]).to eq(4)
    end

    it 'Passes the update project use case the timestamp' do
      expect(update_baseline_spy).to have_received(:execute).with(
        hash_including(
          timestamp: 5
        )
      )
    end

    it 'Calls execute on the convert usecase' do
      expect(convert_ui_project_spy).to have_received(:execute)
    end

    it 'Passes data and type to the convert use case' do
      expect(convert_ui_project_spy).to have_received(:execute).with(
        project_data: { cat: 'meow' }, type: 'hif'
      )
    end

    it 'Passes the update project use case the converted project data' do
      expect(update_baseline_spy).to(
        have_received(:execute).with(
          hash_including(
            project_data: { catto: 'meow' }
          )
        )
      )
    end
  end

  context 'Example two' do
    let(:update_baseline_spy) { spy(execute: { successful: false, errors: [:incorrect_timestamp], timestamp: 8 }) }
    let(:convert_ui_project_spy) { spy(execute: { doggo: 'woof' }) }
    let(:use_case) do
      described_class.new(
        update_baseline: update_baseline_spy,
        convert_ui_project: convert_ui_project_spy
      )
    end
    let(:response) { use_case.execute(id: 2, type: 'type', data: { dog: 'woof' }, timestamp: 8) }

    before { response }

    it 'Calls execute on the update project usecase' do
      expect(update_baseline_spy).to have_received(:execute)
    end

    it 'Passes the update project use case the project ID' do
      expect(update_baseline_spy).to(
        have_received(:execute).with(hash_including(project_id: 2))
      )
    end

    it 'Returns unsuccessful if unsuccessful' do
      expect(response[:successful]).to eq(false)
    end

    it 'Returns the errors array' do
      expect(response[:errors]).to eq([:incorrect_timestamp])
    end

    it 'Returns the timestamp' do
      expect(response[:timestamp]).to eq(8)
    end
    
    it 'Passes the update project use case the timestamp' do
      expect(update_baseline_spy).to have_received(:execute).with(
        hash_including(
          timestamp: 8
        )
      )
    end

    it 'Calls execute on the convert usecase' do
      expect(convert_ui_project_spy).to have_received(:execute)
    end

    it 'Converts the project data' do
      expect(convert_ui_project_spy).to have_received(:execute).with(
        project_data: { dog: 'woof' }, type: 'type'
      )
    end

    it 'Passes the update project use case the converted project data' do
      expect(update_baseline_spy).to(
        have_received(:execute).with(
          hash_including(
            project_data: { doggo: 'woof' }
          )
        )
      )
    end
  end
end
