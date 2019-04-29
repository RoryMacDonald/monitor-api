class HomesEngland::UseCase::CreateNewRmReview
  def initialize(project_gateway: , rm_review_gateway:)
    @project_gateway = project_gateway
    @rm_review_gateway = rm_review_gateway
  end

  def execute(project_id:, review_data:)
    @project_gateway.find_by(id: project_id)
    rm_review = HomesEngland::Domain::RmReview.new.tap do |review|
      review.project_id = project_id
      review.data = review_data
    end

    rm_review_id = @rm_review_gateway.create(rm_review)
    {id: rm_review_id}
  end
end
