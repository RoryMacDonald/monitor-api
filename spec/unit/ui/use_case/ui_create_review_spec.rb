fdescribe UI::UseCase::UiCreateReview do

  let(:usecase) { described_class.new(
    convert_ui_review: convert_ui_review_spy,
    create_review: create_review_spy,
    find_project: find_project_spy
  )}

  context 'example 1' do
    let(:find_project_spy) { spy(execute: {type: 'hif'}) }
    let(:convert_ui_review_spy) { spy(execute: {data: 'cat' }) }
    let(:create_review_spy) { spy(execute: { id: 66 }) }
    let(:response) { usecase.execute(project_id: 2, review_data:{}) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'calls convert ui review' do
      response
      expect(convert_ui_review_spy).to have_received(:execute).with(type: 'hif',review_data: {})
    end

    it 'calls create review' do
      response
      expect(create_review_spy).to have_received(:execute).with(project_id: 2, review_data: { data: 'cat' })
    end

    it 'returns the created review id' do
      expect(response[:id]).to eq(66)
    end
  end

  context 'example 2' do
    let(:find_project_spy) { spy(execute: {type: 'ac'}) }
    let(:convert_ui_review_spy) { spy(execute: {data: 'dog'}) }
    let(:create_review_spy) { spy(execute: { id: 99 }) }
    let(:response) { usecase.execute(project_id: 7, review_data:{ date: '10/10/1010'}) }

    it 'calls find project' do
      response
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    it 'calls convert ui review' do
      response
      expect(convert_ui_review_spy).to have_received(:execute).with(type: 'ac', review_data: { date: '10/10/1010' })
    end

    it 'calls create review' do
      response
      expect(create_review_spy).to have_received(:execute).with(project_id: 7, review_data: { data: 'dog' })
    end

    it 'returns the created review id' do
      expect(response[:id]).to eq(99)
    end
  end
end
