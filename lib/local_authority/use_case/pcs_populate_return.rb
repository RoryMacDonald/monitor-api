class LocalAuthority::UseCase::PcsPopulateReturn
  def initialize(get_return:, pcs_gateway:)
    @get_return = get_return
    @pcs_gateway = pcs_gateway
  end

=begin
project_manager = "Kate Taylor"
sponsor = "Gareth Blacker"
actuals = [
  {
    "bidIdentifier": "HIF/MV/265",
    "projectIdentifier": "29719",
    "dateInfo": {
      "period": "2018/19", //This is very important to ac, both baseline and return
      "monthNumber": 10
    },
    "phase": {
      "name": "Capital Grant (CDEL)",
      "number": 1
    },
    "expense": {
      "code": 162,
      "description": "Capital contribution to local authority"
    },
    "previousYearPaymentsToDate": 0,
    "payments": {
      "currentYearPayments": [ //This probably has a maximum of 4 for each quarter in actuality
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ]
    }
  },
  {
    "bidIdentifier": "HIF/MV/265",
    "projectIdentifier": "29719",
    "dateInfo": {
      "period": "2018/19",
      "monthNumber": 10
    },
    "phase": {
      "name": "Resource Grant (RDEL)",
      "number": 2
    },
    "expense": {
      "code": 396,
      "description": "Revenue contribution to local authority"
    },
    "previousYearPaymentsToDate": 0,
    "payments": {
      "currentYearPayments": [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ]
    }
  }
]
=end

  def execute(id:, api_key:)
    return_data = @get_return.execute(id: id)

    unless return_data[:status] == 'Submitted' || ENV['PCS'].nil?
      pcs_data = @pcs_gateway.get_project(
        api_key: api_key, bid_id: return_data[:bid_id]
      )

      return_data[:updates][-1][:grantExpenditure] = [{}] if return_data[:updates][-1][:grantExpenditure].nil?
      return_data[:updates][-1][:grantExpenditure][0][:year] = pcs_data.actuals[0][:dateInfo][:period]
      return_data[:updates][-1][:grantExpenditure][0][:Q1Amount] = pcs_data.actuals[0][:payments][:currentYearPayments][0].to_s
      return_data[:updates][-1][:grantExpenditure][0][:Q2Amount] = pcs_data.actuals[0][:payments][:currentYearPayments][1].to_s
      return_data[:updates][-1][:grantExpenditure][0][:Q3Amount] = pcs_data.actuals[0][:payments][:currentYearPayments][2].to_s
      return_data[:updates][-1][:grantExpenditure][0][:Q4Amount] = pcs_data.actuals[0][:payments][:currentYearPayments][3].to_s
    end

    return_data
  end
end
