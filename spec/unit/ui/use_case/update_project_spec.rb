# frozen_string_literal: true

describe UI::UseCase::UpdateProject do
  context 'Example one' do
    let(:update_project_spy) { spy(execute: { successful: true, errors: [] }) }
    let(:convert_ui_hif_project_spy) { spy(execute: { catto: 'meow' }) }
    let(:use_case) do
      described_class.new(
        update_project: update_project_spy,
        convert_ui_hif_project: convert_ui_hif_project_spy
      )
    end
    let(:response) do
      use_case.execute(id: 7, type: 'hif', data: { cat: 'meow' }, timestamp: 5)
    end

    before { response }

    it 'Calls execute on the update project usecase' do
      expect(update_project_spy).to have_received(:execute)
    end

    it 'Passes the update project use case the project ID' do
      expect(update_project_spy).to(
        have_received(:execute).with(hash_including(project_id: 7))
      )
    end

    it 'Returns successful if successful' do
      expect(response[:successful]).to eq(true)
    end

    it 'Returns the errors array' do
      expect(response[:errors]).to eq([])
    end

    it 'Passes the update project use case the timestamp' do
      expect(update_project_spy).to have_received(:execute).with(
        hash_including(
          timestamp: 5
        )
      )
    end

    context 'Given a hif project' do
      it 'Calls execute on the convert usecase' do
        expect(convert_ui_hif_project_spy).to have_received(:execute)
      end

      it 'Converts the project data' do
        expect(convert_ui_hif_project_spy).to have_received(:execute).with(
          project_data: { cat: 'meow' }
        )
      end

      it 'Passes the update project use case the converted project data' do
        expect(update_project_spy).to(
          have_received(:execute).with(
            hash_including(
              project_data: { catto: 'meow' }
            )
          )
        )
      end
    end

    context 'Given a non-hif project' do
      let(:response) do
        use_case.execute(id: 7, type: 'ac', data: { cat: 'meow' }, timestamp: 6)
      end

      it 'Does not call execute on the convert usecase' do
        expect(convert_ui_hif_project_spy).not_to have_received(:execute)
      end

      it 'Passes the update project use case the non-converted project data' do
        expect(update_project_spy).to(
          have_received(:execute).with(
            hash_including(
              project_data: { cat: 'meow' }
            )
          )
        )
      end
    end
  end

  context 'Example two' do
    let(:update_project_spy) { spy(execute: { successful: false, errors: [:incorrect_timestamp] }) }
    let(:convert_ui_hif_project_spy) { spy(execute: { doggo: 'woof' }) }
    let(:use_case) do
      described_class.new(
        update_project: update_project_spy,
        convert_ui_hif_project: convert_ui_hif_project_spy
      )
    end
    let(:response) { use_case.execute(id: 2, type: 'hif', data: { dog: 'woof' }, timestamp: 8) }

    before { response }

    it 'Calls execute on the update project usecase' do
      expect(update_project_spy).to have_received(:execute)
    end

    it 'Passes the update project use case the project ID' do
      expect(update_project_spy).to(
        have_received(:execute).with(hash_including(project_id: 2))
      )
    end

    it 'Returns unsuccessful if unsuccessful' do
      expect(response[:successful]).to eq(false)
    end

    it 'Returns the errors array' do
      expect(response[:errors]).to eq([:incorrect_timestamp])
    end
    
    it 'Passes the update project use case the timestamp' do
      expect(update_project_spy).to have_received(:execute).with(
        hash_including(
          timestamp: 8
        )
      )
    end

    context 'Given a hif project' do
      it 'Calls execute on the convert usecase' do
        expect(convert_ui_hif_project_spy).to have_received(:execute)
      end

      it 'Converts the project data' do
        expect(convert_ui_hif_project_spy).to have_received(:execute).with(
          project_data: { dog: 'woof' }
        )
      end

      it 'Passes the update project use case the converted project data' do
        expect(update_project_spy).to(
          have_received(:execute).with(
            hash_including(
              project_data: { doggo: 'woof' }
            )
          )
        )
      end
    end

    context 'Given a non-hif project' do
      let(:response) do
        use_case.execute(id: 7, type: 'ac', data: { dog: 'woof' }, timestamp: 6)
      end

      it 'Does not call execute on the convert usecase' do
        expect(convert_ui_hif_project_spy).not_to have_received(:execute)
      end

      it 'Passes the update project use case the non-converted project data' do
        expect(update_project_spy).to(
          have_received(:execute).with(
            hash_including(
              project_data: { dog: 'woof' }
            )
          )
        )
      end
    end
  end
end
