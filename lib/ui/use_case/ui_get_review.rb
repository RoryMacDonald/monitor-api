class UI::UseCase::UiGetReview
  def initialize(convert_core_review:, get_review:, find_project:)
    @find_project = find_project
    @get_review = get_review
    @convert_core_review = convert_core_review
  end

  def execute(project_id:, review_id:)
    project = @find_project.execute(id: project_id)
    review = @get_review.execute(review_id: review_id)
    review_data = @convert_core_review.execute(type: project[:type], review_data: review[:data])

    {
      id: review[:id],
      project_id: project_id,
      data: review_data,
      status: review[:status]
    }
  end
end
