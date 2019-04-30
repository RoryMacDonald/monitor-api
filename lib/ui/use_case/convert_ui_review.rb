class UI::UseCase::ConvertUIReview
  def initialize(convert_ui_hif_review: )
    @convert_ui_hif_review = convert_ui_hif_review
  end

  def execute(type:, review_data:)
    return @convert_ui_hif_review.execute(review_data: review_data) if type == 'hif'
    nil
  end
end
