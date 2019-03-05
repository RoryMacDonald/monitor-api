# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:projects) do
      add_column :version, Integer, default: 1
    end
  end
end
