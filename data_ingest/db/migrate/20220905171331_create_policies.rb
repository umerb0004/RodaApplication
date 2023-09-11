# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :policies do
      primary_key :id

      column :type, String

      column :division, Integer
      column :written_premium, Float
      column :carrier_policy_number, Integer

      column :carrier_id, Integer
      column :client_id, Integer

      column :effective_date, Date
      column :expiration_date, Date
    end

  end
end
