# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:returns) do
      add_column :baseline_version, Integer, default: 1
    end
  end
end
