class LocalAuthority::UseCase::PcsPopulateReturn
  def initialize(get_return:, pcs_gateway:)
    @get_return = get_return
    @pcs_gateway = pcs_gateway
  end

  def execute(id:, api_key:)
    return_data = @get_return.execute(id: id)

    unless return_data[:status] == 'Submitted' || ENV['PCS'].nil?
      pcs_data = @pcs_gateway.get_project(
        api_key: api_key, bid_id: return_data[:bid_id]
      )

      unless pcs_data.actuals.nil?
        return_data[:updates].last[:grantExpenditure] = {} if return_data.dig(:updates, -1, :grantExpenditure).nil?
        existingClaimedToDate = return_data.dig(:updates, -1, :grantExpenditure, :claimedToDate).to_a
        return_data[:updates].last[:grantExpenditure][:claimedToDate] = pcs_data.actuals.zip(existingClaimedToDate).map do |pcs, claim|
          pulled_pcs_data = {
            year: pcs.dig(:dateInfo, :period),
            Q1Amount: pcs.dig(:payments, :currentYearPayments, 0).to_s,
            Q2Amount: pcs.dig(:payments, :currentYearPayments, 1).to_s,
            Q3Amount: pcs.dig(:payments, :currentYearPayments, 2).to_s,
            Q4Amount: pcs.dig(:payments, :currentYearPayments, 3).to_s
          }

          merge_if_existing(claim, pulled_pcs_data)
        end
      end
    end

    return_data
  end

  private

  def merge_if_existing(hash_to_merge, default)
    if hash_to_merge.nil?
      default
    else
      hash_to_merge.merge(default)
    end
  end
end
