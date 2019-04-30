class HomesEngland::Gateway::SequelReview
  def initialize(database:)
    @database = database
  end

  def create(review)
    @database[:reviews].insert(
      project_id: review.project_id,
      data: Sequel.pg_json(review.data),
      status: review.status
    )
  end

  def find_by(id:)
    @database[:reviews].where(id: id).first.then do |retrieved_review|
      HomesEngland::Domain::RmReview.new.tap do |review|
        review.id = retrieved_review[:id]
        review.project_id = retrieved_review[:project_id]
        review.data = Common::DeepSymbolizeKeys.to_symbolized_hash(retrieved_review[:data].to_h)
        review.status = retrieved_review[:status]
      end
    end
  end
end
