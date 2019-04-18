# frozen_string_literal: true

class LocalAuthority::UseCase::GetReturn
  def initialize(return_gateway:, return_update_gateway:, get_returns:)
    @return_gateway = return_gateway
    @return_update_gateway = return_update_gateway
    @get_returns = get_returns
  end

  def execute(id:)
    found_return = @return_gateway.find_by(id: id)
    project_id = found_return.project_id
    updates = @return_update_gateway.updates_for(return_id: id)

    previous_returns = @get_returns.execute(project_id: project_id)[:returns].select do |return_data|
      return_data[:status] == 'Submitted' && return_data[:id] < found_return.id
    end

    number_of_previous_returns = previous_returns.length

    previous_return_data = previous_returns.dig(-1, :updates, -1)

    if found_return.nil?
      {}
    else
      {
        id: found_return.id,
        type: found_return.type,
        bid_id: found_return.bid_id,
        project_id: found_return.project_id,
        status: found_return.status,
        updates: updates.map(&:data),
        timestamp: found_return.timestamp,
        no_of_previous_returns: number_of_previous_returns,
        baseline_version: found_return.baseline_version
      }
    end
  end
end
