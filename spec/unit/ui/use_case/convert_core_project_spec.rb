# frozen_string_literal: true


describe UI::UseCase::ConvertCoreProject do
  context 'Example one' do
    let(:convert_core_ac_project_spy) { spy(execute: { data: 'ac_converted' })}
    let(:convert_core_hif_project_spy) { spy(execute: { data: 'converted' })}
    let(:convert_core_ff_project_spy) { spy(execute: {data: 'ff converted'}) }
    let(:sanitise_data_spy) { spy(execute: {data: 'nonempty'}) }

    let(:use_case) do
      described_class.new(
        convert_core_hif_project: convert_core_hif_project_spy,
        convert_core_ac_project: convert_core_ac_project_spy,
        convert_core_ff_project: convert_core_ff_project_spy,
        sanitise_data: sanitise_data_spy
      )
    end

    it 'sanitises the data' do
      use_case.execute(type: 'hif', project_data: { some_data: 'data value' })

      expect(sanitise_data_spy).to have_received(:execute).with(
        data: { data: 'converted' }
      )
    end

    context 'HIF data' do
      let(:response) { use_case.execute(project_data: { data: 'from the core' }, type: 'hif')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_hif_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the core' }
        )
      end
    end

    context 'AC data' do
      let(:response) { use_case.execute(project_data: { data: 'from the core' }, type: 'ac')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_ac_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the core' }
        )
      end
    end

    context 'FF data' do
      let(:convert_core_ff_project_spy) { spy(execute: {data: 'ff converted'}) }
      let(:response) { use_case.execute(project_data: { data: 'from the core' }, type: 'ff')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_ff_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the core' }
        )
      end
    end

    context 'another type' do
      let(:response) { use_case.execute(project_data: { data: 'from the core' }, type: 'other')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_ac_project_spy).not_to have_received(:execute)
      end
    end

      
    it 'returns the sanitised data' do
      response = use_case.execute(type: 'hif', project_data: { some_data: 'data value' })

      expect(response).to eq({data: 'nonempty'})
    end
  end

  context 'Example two' do
    let(:convert_core_ac_project_spy) { spy(execute: { data: 'ready for the ac core' })}
    let(:convert_core_ff_project_spy) { spy(execute: { data: 'ready for the ff core' })}
    let(:convert_core_hif_project_spy) { spy(execute: { data: 'done for hif' })}
    let(:sanitise_data_spy) { spy(execute: {data: 'no nils'}) }

    let(:use_case) do
      described_class.new(
        convert_core_hif_project: convert_core_hif_project_spy,
        convert_core_ac_project: convert_core_ac_project_spy,
        convert_core_ff_project: convert_core_ff_project_spy,
        sanitise_data: sanitise_data_spy
      )
    end

    it 'sanitises the data' do
      use_case.execute(type: 'hif', project_data: { some_data: 'data value' })

      expect(sanitise_data_spy).to have_received(:execute).with(
        data: { data: 'done for hif' }
      )
    end

    context 'HIF data' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'hif')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_hif_project_spy).to have_received(:execute).with(
          project_data: { data: 'data ready to be changed' }
        )
      end
    end

    context 'AC data' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'ac')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_ac_project_spy).to have_received(:execute).with(
          project_data: { data: 'data ready to be changed' }
        )
      end
    end

    context 'FF data' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'ff')}

      before { response }

      it 'Calls the convert core ff project use case with the project data' do
        expect(convert_core_ff_project_spy).to have_received(:execute).with(
          project_data: { data: 'data ready to be changed' }
        )
      end
    end

    context 'another type' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'other')}

      before { response }

      it 'Calls the convert core hif project use case with the project data' do
        expect(convert_core_ac_project_spy).not_to have_received(:execute)
      end
    end

    it 'returns the sanitised data' do
      response = use_case.execute(type: 'hif', project_data: { some_data: 'data value' })

      expect(response).to eq({data: 'no nils'})
    end

  end
end
