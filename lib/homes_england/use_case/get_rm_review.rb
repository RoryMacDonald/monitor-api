class HomesEngland::UseCase::GetRmReview

  def initialize(rm_review_gateway:)
    @rm_review_gateway = rm_review_gateway
  end

  def execute(review_id:)
    @rm_review_gateway.find_by(id: review_id).then do |review|
      {
        id: review.id,
        project_id: review.project_id,
        data: review.data,
        status: review.status
      }
    end
  end
end
