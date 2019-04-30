fdescribe HomesEngland::UseCase::GetRmReview do

  let(:rm_review_gateway_spy) { spy(find_by: review) }
  let(:get_review) do
    described_class.new(rm_review_gateway: rm_review_gateway_spy)
  end

  context 'example 1' do
    let(:review) do
      HomesEngland::Domain::RmReview.new.tap do | review |
        review.id = 1
        review.project_id = 2
        review.data = {cats: 'feed me'}
        review.status = 'Draft'
      end
    end

    it 'calls the review gateway with find_by' do
      get_review.execute(review_id: 1)

      expect(rm_review_gateway_spy).to have_received(:find_by).with(id: 1)
    end

    it 'returns a hash of a review' do
      review = get_review.execute(review_id: 1)

      expect(review[:id]).to eq(1)
      expect(review[:project_id]).to eq(2)
      expect(review[:data]).to eq({ cats: 'feed me'})
      expect(review[:status]).to eq('Draft')
    end
  end

  context 'example 2' do
    let(:review) do
      HomesEngland::Domain::RmReview.new.tap do | review |
        review.id = 3
        review.project_id = 7
        review.data = {cats: 'in hats'}
        review.status = 'Submitted'
      end
    end

    it 'calls the review gateway with find_by' do
      get_review.execute(review_id: 3)

      expect(rm_review_gateway_spy).to have_received(:find_by).with(id: 3)
    end

    it 'returns a hash of a review' do
      review = get_review.execute(review_id: 3)

      expect(review[:id]).to eq(3)
      expect(review[:project_id]).to eq(7)
      expect(review[:data]).to eq({ cats: 'in hats'})
      expect(review[:status]).to eq('Submitted')
    end
  end
end
