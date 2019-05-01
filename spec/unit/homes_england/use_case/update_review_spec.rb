fdescribe HomesEngland::UseCase::UpdateReview do
  let(:review_gateway) { spy }

  let(:usecase) do
    described_class
      .new(review_gateway: review_gateway)
  end

  context 'example 1' do
    let(:review_data) { { date: '09/09/1978' } }
    it 'Calls the update method on the gateway' do
      usecase
        .execute(review_id: 3, review_data: review_data)

      expect(review_gateway).to have_received(:update) do |review|
        expect(review.id).to eq(3)
        expect(review.data).to eq(review_data)
      end
    end
  end

  context 'example 2' do
    let(:review_data) { { date: '12/09/1980' } }

    it 'Calls the update method on the gateway' do
      usecase
        .execute(review_id: 8, review_data: review_data)

      expect(review_gateway).to have_received(:update) do |review|
        expect(review.id).to eq(8)
        expect(review.data).to eq(review_data)
      end
    end
  end
end
