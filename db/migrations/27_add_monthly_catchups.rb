Sequel.migration do
  change do
    create_table :monthly_catchups do
      primary_key :id, type: :Bignum
      column :project_id, :Bignum, index: true
      String :status
      column :data, 'json'
    end
  end
end
