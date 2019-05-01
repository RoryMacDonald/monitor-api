class HomesEngland::UseCase::UpdateReview

  def initialize(review_gateway:)
    @review_gateway = review_gateway
  end

  def execute(review_id:, review_data:)
    review = HomesEngland::Domain::RmReview.new.tap do |review|
      review.id = review_id
      review.data = review_data
    end

    @review_gateway.update(review)
  end
end
