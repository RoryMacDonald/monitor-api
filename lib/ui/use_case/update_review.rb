class UI::UseCase::UpdateReview

  def initialize(convert_ui_review:, find_project:, update_review:)
    @convert_ui_review = convert_ui_review
    @find_project = find_project
    @update_review = update_review
  end

  def execute(project_id:, review_id:, review_data:)
    project = @find_project.execute(id: project_id)
    converted_ui_data = @convert_ui_review.execute(type: project[:type], review_data: review_data)
    @update_review.execute(review_id: review_id, review_data: converted_ui_data)
  end
end
