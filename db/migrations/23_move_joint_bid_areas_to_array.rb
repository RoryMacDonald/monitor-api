# frozen_string_literal: true

Sequel.migration do
  up do
    projects = from(:projects)
    projects.each do |project|
      next unless project[:type] == 'hif'

      project_baselines = from(:baselines).where(project_id: project[:id]).all

      project_baselines.each do |baseline|
        new_data = baseline[:data]

        if new_data['summary'] && new_data['summary']['jointBidAreas']
          new_data['summary']['jointBidAuthorityAreas'] = [new_data['summary']['jointBidAreas']]
        end


        from(:baselines).where(id: baseline[:id]).update(data: new_data)
      end
    end
  end

  down do
  end
end
