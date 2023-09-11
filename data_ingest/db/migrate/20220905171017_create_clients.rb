# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :clients do
      primary_key :id

      column :name, String
      column :description, String

      column :address, String
      column :city, String
      column :state, String

      column :division, String
      column :major_group, Integer
      column :industry_group, Integer
      column :sic, Integer
    end
  end
end
