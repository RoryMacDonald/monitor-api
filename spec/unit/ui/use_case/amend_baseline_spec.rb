# frozen_string_literal: true

describe UI::UseCase::AmendBaseline do
  context 'Example 1' do
    let(:amend_baseline_spy) do
      spy(execute: {
        success: true,
        id: 3
      })
    end
    let(:convert_ui_project_spy) { spy(execute: { dogs: 'bark' })}
    let(:find_project_spy) { spy(execute: {type: 'hi'})}

    let(:usecase) do
      described_class.new(
        amend_baseline: amend_baseline_spy,
        convert_ui_project: convert_ui_project_spy,
        find_project: find_project_spy
      )
    end
  
    let(:response) do
      usecase.execute(project_id: 1, data: {}, timestamp: 3)
    end
  
    before { response }
    
    it 'calls the amend baseline use case with the project ID' do
      expect(amend_baseline_spy).to have_received(:execute).with(
        hash_including(project_id: 1)
      )
    end

    it 'calls the find project use case with the project ID' do
      expect(find_project_spy).to have_received(:execute).with(
        hash_including(id: 1)
      )
    end

    it 'calls the convertor with the data and type' do
      expect(convert_ui_project_spy).to have_received(:execute).with(
        hash_including(project_data: {}, type: 'hi')
      )
    end

    it 'calls the amend baseline use case with the timestamp' do
      expect(amend_baseline_spy).to have_received(:execute).with(
        hash_including(timestamp: 3)
      )
    end

    it 'calls the amend baseline use case with the converted data' do
      expect(amend_baseline_spy).to have_received(:execute).with(
        hash_including(data: { dogs: 'bark' })
      )
    end

    it 'returns what is returned from the usecase' do
      expect(response).to eq({success: true, id: 3})
    end
  end

  context 'Example 2' do
    let(:amend_baseline_spy) do
      spy(execute: {
        success: true,
        id: 5
      })
    end
    let(:convert_ui_project_spy) { spy(execute: { cats: 'meow' })}
    let(:find_project_spy) { spy(execute: {type: 'bye'})}

    let(:usecase) do
      described_class.new(
        amend_baseline: amend_baseline_spy,
        convert_ui_project: convert_ui_project_spy,
        find_project: find_project_spy
      )
    end
  
    let(:response) do
      usecase.execute(project_id: 7, data: {}, timestamp: 345)
    end
  
    before { response }
    
    it 'calls the amend baseline use case with the project ID' do
      expect(amend_baseline_spy).to have_received(:execute).with(
        hash_including(project_id: 7)
      )
    end

    it 'calls the find project use case with the project ID' do
      expect(find_project_spy).to have_received(:execute).with(
        hash_including(id: 7)
      )
    end

    it 'calls the convertor with the data and type' do
      expect(convert_ui_project_spy).to have_received(:execute).with(
        hash_including(project_data: {}, type: 'bye')
      )
    end

    it 'calls the amend baseline use case with the timestamp' do
      expect(amend_baseline_spy).to have_received(:execute).with(
        hash_including(timestamp: 345)
      )
    end

    it 'calls the amend baseline use case with the converted data' do
      expect(amend_baseline_spy).to have_received(:execute).with(
        hash_including(data: { cats: 'meow' })
      )
    end

    it 'returns what is returned from the usecase' do
      expect(response).to eq({success: true, id: 5})
    end
  end
end
