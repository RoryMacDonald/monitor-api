class HomesEngland::UseCase::CreateNewRmReview
  def initialize(rm_review_gateway:)
    @rm_review_gateway = rm_review_gateway
  end

  def execute(project_id:, review_data:)
    rm_review = HomesEngland::Domain::RmReview.new.tap do |review|
      review.project_id = project_id
      review.data = review_data
    end

    rm_review_id = @rm_review_gateway.create(rm_review)

    { id: rm_review_id }
  end
end
