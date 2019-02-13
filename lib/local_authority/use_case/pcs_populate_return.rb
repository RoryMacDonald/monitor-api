class LocalAuthority::UseCase::PcsPopulateReturn
  def initialize(get_return:, pcs_gateway:)
    @get_return = get_return
    @pcs_gateway = pcs_gateway
  end

  def execute(id:, api_key:)
    return_data = @get_return.execute(id: id)

    unless return_data[:status] == 'Submitted' || ENV['PCS'].nil?
      @pcs_gateway.get_project(
        api_key: api_key, bid_id: return_data[:bid_id]
      )
    end

    return_data
  end
end
