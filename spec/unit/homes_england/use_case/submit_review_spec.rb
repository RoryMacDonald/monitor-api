fdescribe HomesEngland::UseCase::SubmitReview do
  let(:review_gateway) { spy }

  context 'calls submit on the review gateway' do
    example 1 do
      described_class.new(review_gateway: review_gateway).execute(review_id: 22)
      expect(review_gateway).to have_received(:submit).with(id: 22)
    end

    example 2 do
      described_class.new(review_gateway: review_gateway).execute(review_id: 33)
      expect(review_gateway).to have_received(:submit).with(id: 33)
    end
  end
end
