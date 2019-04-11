# frozen_string_literal: true

Sequel.migration do
  up do
    updates = from(:return_updates)
    updates.each do |update|
      new_data = update[:data]
      new_data[:outputsActuals] = [update[:data]["outputsActuals"]]
      from(:return_updates).where(id: update[:id]).update(data: new_data)
    end
  end

  down do
  end
end
