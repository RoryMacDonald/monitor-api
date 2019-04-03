Sequel.migration do
  up do
    alter_table(:projects) do
      add_column :data, 'json'
      add_column :timestamp, Integer, default: 0
    end
    
    projects = from(:projects)

    projects.each do |project|
      next if !project.nil? && project[:type] != 'hif'
      baselines = from(:baselines).where(project_id: project[:id]).order.all

      baselines = baselines.select { |base| base[:status] == 'Submitted' } if baselines.length > 1

      last_baselines_data = baselines.last[:data]
      admin_data = last_baselines_data['rmBaseline']
      admin_data['projectDetails'] = {
        'BIDReference': project[:bid_id],
        'pcsNumber': last_baselines_data['summary']['pcsNumber']

      }

      from(:projects).where(id: project[:id]).update(data: Sequel.pg_json(admin_data))
    end
  end

  down do
    alter_table(:projects) do
      drop_column :data
      drop_column :timestamp
    end
  end
end