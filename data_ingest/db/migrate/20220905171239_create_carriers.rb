# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :carriers do
      primary_key :id

      column :name, String

      column :address, String
      column :city, String
      column :state, String
      column :zip, Integer
    end
  end
end
