class HomesEngland::Gateway::SequelMonthlyCatchup
  def initialize(database:)
    @database = database
  end

  def create(monthly_catchup)
    @database[:monthly_catchups].insert(
      project_id: monthly_catchup.project_id,
      data: Sequel.pg_json(monthly_catchup.data),
      status: monthly_catchup.status
    )
  end

  def find_by(id:)
    @database[:monthly_catchups].where(id: id).first.then do |retrieved_monthly_catchup|
      HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
        monthly_catchup.id = retrieved_monthly_catchup[:id]
        monthly_catchup.project_id = retrieved_monthly_catchup[:project_id]
        monthly_catchup.data = Common::DeepSymbolizeKeys.to_symbolized_hash(retrieved_monthly_catchup[:data].to_h)
        monthly_catchup.status = retrieved_monthly_catchup[:status]
      end
    end
  end

  def update(monthly_catchup)
    @database[:monthly_catchups].where(id: monthly_catchup.id).update(data: Sequel.pg_json(monthly_catchup.data))
  end

  def submit(id:)
    @database[:monthly_catchups].where(id: id).update(status: 'Submitted')
  end
end
