# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:projects) do
      add_column :bid_id, String
    end
  end
end
