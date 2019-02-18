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
        total = pcs_data.actuals.reduce(0) do |sum, actual|
          sum + actual.dig(:payments,:currentYearPayments).sum + actual[:previousYearPaymentsToDate].to_i
        end
        return_data[:updates][-1][:s151GrantClaimApproval] = {} if return_data[:s151GrantClaimApproval].nil?
        return_data[:updates][-1][:s151GrantClaimApproval][:SpendToDate] = total.to_s
      end
    end
    return_data
  end
end
