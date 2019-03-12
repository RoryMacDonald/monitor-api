class LocalAuthority::UseCase::PcsPopulateReturn
  def initialize(get_return:, pcs_gateway:)
    @get_return = get_return
    @pcs_gateway = pcs_gateway
  end

  def execute(id:)
    return_data = @get_return.execute(id: id)

    unless return_data[:status] == 'Submitted' || ENV['PCS'].nil?
      pcs_data = @pcs_gateway.get_project(bid_id: return_data[:bid_id])

      unless pcs_data.nil? || pcs_data.actuals.nil?
        return_data[:updates][-1] = add_ac_figures(return_data[:updates][-1], pcs_data.actuals) if return_data[:type] == 'ac'
      end
    end
    return_data
  end

  private

  def add_ac_figures(return_data, actuals)
    year = actuals[0][:dateInfo][:period]

    q1_total = q2_total = q3_total = q4_total = 0

    actuals.each do |actual|
      payments = actual.dig(:payments,:currentYearPayments)
      q1_total += sum_figures(payments[0, 3])
      q2_total += sum_figures(payments[3, 3])
      q3_total += sum_figures(payments[6, 3])
      q4_total += sum_figures(payments[9, 3])
    end

    return_data[:grantExpenditure] = {} unless return_data[:grantExpenditure]
    return_data[:grantExpenditure][:claimedToDate] = [] unless return_data[:grantExpenditure][:claimedToDate]
    return_data[:grantExpenditure][:claimedToDate].reject!{ |profile| profile[:year] == year}


    return_data[:grantExpenditure][:claimedToDate].push({
      year: year,
      Q1Amount: q1_total.to_s,
      Q2Amount: q2_total.to_s,
      Q3Amount: q3_total.to_s,
      Q4Amount: q4_total.to_s
    })

    return_data
  end

  def sum_figures(array)
    return 0 if array.nil?
    array.sum { |amount| amount.to_i }
  end
end
