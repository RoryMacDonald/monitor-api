class LocalAuthority::UseCase::PcsPopulateClaim
  def initialize(get_claim_core:, pcs_gateway:)
    @get_claim_core = get_claim_core
    @pcs_gateway = pcs_gateway
  end

  def execute(claim_id:)
    found_claim = @get_claim_core.execute(claim_id: claim_id)
    unless ENV['PCS'].nil?
      pcs_data = @pcs_gateway.get_project(bid_id: found_claim[:bid_id])
      unless pcs_data.nil?
        total = get_spend_to_date(pcs_data)
        if found_claim[:type] == 'hif'
          found_claim[:data][:claimSummary] = {} if found_claim.dig(:data, :claimSummary).nil?
          found_claim[:data][:claimSummary][:hifSpendToDate] = total.to_s
        else
          found_claim[:data][:SpendToDate] = total.to_s
        end
      end
    end

    found_claim
  end

  def get_spend_to_date(pcs_data)
    pcs_data.actuals.reduce(0) do |sum, actual|
      sum + actual.dig(:payments,:currentYearPayments).sum + actual[:previousYearPaymentsToDate].to_i
    end
  end
end
