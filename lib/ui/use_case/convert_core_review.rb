class UI::UseCase::ConvertCoreReview

  def initialize(convert_core_hif_review:)
    @convert_core_hif_review = convert_core_hif_review
  end

  def execute(type:, review_data:)
    return @convert_core_hif_review.execute(review_data: review_data) if type == 'hif'
    nil
  end
end
