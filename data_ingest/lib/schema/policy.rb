require 'dry/schema'
require_relative '../normalizers/instance'
require_relative '../normalizers/rename'

module Schema
  class Policy < Normalizers::Instance
    extend Normalizers::Rename

    params :id, :integer
    params :type, :division, :string

    rename :carrierid, :integer, as: :carrier_id
    rename :clientid, :integer, as: :client_id
    rename :effectivedate, :date, as: :effective_date
    rename :expirationdate, :date, as: :expiration_date
    rename :writtenpremium, :string, as: :written_premium
    rename :carrierpolicynumber, :string, as: :carrier_policy_number

    SCHEMA = Dry::Schema.Params do
      required(:id).filled(:integer)
      required(:type).maybe(:string)
      required(:division).maybe(:string)

      required(:carrier_id).maybe(:integer)
      required(:client_id).maybe(:integer)

      required(:effective_date).maybe(:date)
      required(:expiration_date).maybe(:date)

      required(:written_premium).maybe(:float)
      required(:carrier_policy_number).maybe(:string)
    end
  end
end