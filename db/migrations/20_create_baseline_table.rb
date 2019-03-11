# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :baselines do
      primary_key :id, type: :Bignum
      column :project_id, :Bignum, index: true
      column :status, String
      column :version, Integer
      column :timestamp, Integer, default: 0
      column :data, 'json'
    end
  end
end
