class UI::UseCase::UiCreateReview

  def initialize(convert_ui_review:, create_review:, find_project:)
    @find_project = find_project
    @convert_ui_review = convert_ui_review
    @create_review = create_review
  end

  def execute(project_id:, review_data:)
    project = @find_project.execute(id: project_id)
    review_data = @convert_ui_review.execute(review_data: review_data, type: project[:type])
    response = @create_review.execute(project_id: project_id, review_data: review_data)
    {
      id: response[:id]
    }
  end
end
