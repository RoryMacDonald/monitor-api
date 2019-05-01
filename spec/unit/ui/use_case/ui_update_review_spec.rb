fdescribe UI::UseCase::UpdateReview do
  let(:convert_ui_review_spy) { spy(execute: converted_data) }
  let(:update_review_spy) { spy }
  let(:usecase) do
    described_class.new(
        find_project: find_project_spy,
        convert_ui_review: convert_ui_review_spy,
        update_review: update_review_spy
      )
  end

  context 'example 1' do
    let(:converted_data) { { my_converted_data: 'my converted value' } }
    let(:find_project_spy) { spy(execute: {type: 'hif'})}
    it 'calls the convert use case' do
      usecase.execute(project_id: 2, review_id: 1, review_data: { my_data: 'my value' })
      expect(convert_ui_review_spy).to have_received(:execute).with(type: 'hif', review_data: { my_data: 'my value' })
    end

    it 'calls the find project use case' do
      usecase.execute(project_id: 2, review_id: 1, review_data: { my_data: 'my value' })

      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'calls the update review usecase with the correct data' do
      usecase.execute(project_id: 2, review_id: 1, review_data: { my_data: 'my value' })

      expect(update_review_spy).to have_received(:execute).with(review_id: 1, review_data: converted_data)
    end
  end

  context 'example 2' do
    let(:converted_data) { { my_converted_data: 'different converted value' } }
    let(:find_project_spy) { spy(execute: {type: 'ac'})}
    it 'calls the convert use case' do
      usecase.execute(project_id: 6, review_id: 9, review_data: { data: 'value' })
      expect(convert_ui_review_spy).to have_received(:execute).with(type: 'ac', review_data: { data: 'value' })
    end

    it 'calls the find project use case' do
      usecase
        .execute(project_id: 6, review_id: 9, review_data: { data: 'value' })

      expect(find_project_spy).to have_received(:execute).with(id: 6)
    end

    it 'calls the update review usecase with the correct data' do
      usecase.execute(project_id: 2, review_id: 5, review_data: { some_data: 'some value' })

      expect(update_review_spy).to have_received(:execute).with(review_id: 5, review_data: converted_data)
    end
  end
end
