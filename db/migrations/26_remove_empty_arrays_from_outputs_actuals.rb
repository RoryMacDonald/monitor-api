# frozen_string_literal: true

Sequel.migration do
  up do
    updates = from(:return_updates)
    updates.each do |update|
      update[:data]["outputsActuals"].then do |outputsActuals|
        if outputsActuals.empty?
          update[:data][:outputsActuals] = [{}]
        end
        from(:return_updates).where(id: update[:id]).update(data: update[:data])
      end
    end
  end

  down do
  end
end
