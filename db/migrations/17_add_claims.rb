# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :claims do
      primary_key :id, type: :Bignum
      column :project_id, :Bignum, index: true
      column :type, String
      column :status, String
      column :data, 'json'
    end
  end
end
