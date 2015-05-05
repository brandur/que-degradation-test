Sequel.migration do
  change do
    create_table :dummy_tuples do
      primary_key :id
      String :name, null: false
    end
  end
end
