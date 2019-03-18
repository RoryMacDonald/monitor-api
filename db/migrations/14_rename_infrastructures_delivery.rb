# frozen_string_literal: true

Sequel.migration do
  up do
    return_updates = from(:return_updates)
    return_updates.each do |return_update|
      return_data = from(:returns).where(id: return_update[:return_id]).first

      next if return_data[:project_id].nil?

      project = from(:projects).where(id: return_data[:project_id]).first

      next if !project.nil? && project[:type] != 'hif'

      return_update_data = return_update[:data]
      if (
        return_update_data.has_key?('reviewAndAssurance') &&
        return_update_data['reviewAndAssurance'].has_key?('infrastructureDelivery')
      )
        return_update_data['reviewAndAssurance']['infrastructureDeliveries'] = return_update_data['reviewAndAssurance']['infrastructureDelivery']
        return_update_data['reviewAndAssurance'].delete('infrastructureDelivery')
      end

      from(:return_updates).where(id: return_update[:id]).update(data: return_update_data)
    end
  end

  down do
  end
end
