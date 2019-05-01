class HomesEngland::UseCase::SubmitReview

  def initialize(review_gateway:)
    @review_gateway = review_gateway
  end

  def execute(review_id:)
    @review_gateway.submit(id: review_id)
  end
end
