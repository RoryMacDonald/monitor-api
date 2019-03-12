# frozen_string_literal: true

Sequel.migration do
  up do
    projects = from(:projects)

    projects.each do |project|
      from(:baselines).insert(
        project_id: project[:id],
        data: project[:data],
        status: project[:status],
        timestamp: project[:timestamp]
      )
    end

    alter_table(:projects) do
      drop_column :data
      drop_column :timestamp
    end
  end

  down do
    baselines = from(:baselines)
    
    alter_table(:projects) do
      add_column :data, 'json'
      add_column :timestamp, Integer, default: 0
    end

    baselines.each do |baseline|
      from(:projects).where(id: baseline[:project_id]).update(
        data: baseline[:data],
        timestamp: baseline[:timestamp],
      )

      from(:baselines).where(id: baseline[:id]).delete
    end
  end
end
