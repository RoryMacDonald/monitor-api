# frozen_string_literal: true

Sequel.migration do
  up do
    updates = from(:return_updates)
    updates.each do |update|
      update[:data]["outputsActuals"].then do |outputsActuals|
        next if outputsActuals.instance_of?(Array)
        
        update[:data][:outputsActuals] = [outputsActuals]
        from(:return_updates).where(id: update[:id]).update(data: update[:data])
      end
    end
  end

  down do
  end
end
