fdescribe UI::UseCase::UiGetReview do
  let(:usecase) { described_class.new(
    convert_core_review: convert_core_review_spy,
    get_review: get_review_spy,
    find_project: find_project_spy
  )}

  context 'example 1' do
    let(:find_project_spy) { spy(execute: { type: 'hif' }) }
    let(:get_review_spy) { spy(execute: { id: 1, data: { animal: 'fox' }, status: 'Draft' }) }
    let(:convert_core_review_spy) { spy(execute: { animal: 'dog'}) }
    let(:response) { usecase.execute(project_id: 1, review_id: 1) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 1)
    end

    it 'calls get review' do
      response
      expect(get_review_spy).to have_received(:execute).with(review_id: 1)
    end

    it 'calls convert core review' do
      response
      expect(convert_core_review_spy).to have_received(:execute).with(type: 'hif', review_data: { animal: 'fox' })
    end

    it 'returns the review' do
      expect(response[:id]).to eq(1)
      expect(response[:project_id]).to eq(1)
      expect(response[:data]).to eq({ animal: 'dog' })
      expect(response[:status]).to eq('Draft')
    end
  end

  context 'example 2' do
    let(:find_project_spy) { spy(execute: { type: 'ac' }) }
    let(:get_review_spy) { spy(execute: { id: 2, data: { name: 'moon moon' }, status: 'Submitted' }) }
    let(:convert_core_review_spy) { spy(execute: { name: 'doggo' }) }
    let(:response) { usecase.execute(project_id: 2, review_id: 2) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'calls get review' do
      response
      expect(get_review_spy).to have_received(:execute).with(review_id: 2)
    end

    it 'calls convert core review' do
      response
      expect(convert_core_review_spy).to have_received(:execute).with(type: 'ac', review_data: { name: 'moon moon' })
    end

    it 'returns the review' do
      expect(response[:id]).to eq(2)
      expect(response[:project_id]).to eq(2)
      expect(response[:data]).to eq({ name: 'doggo' })
      expect(response[:status]).to eq('Submitted')
    end
  end
end
