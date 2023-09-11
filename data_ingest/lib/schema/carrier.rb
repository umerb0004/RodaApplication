require 'dry/schema'
require_relative '../normalizers/instance'
require_relative '../normalizers/rename'
require_relative '../normalizers/combine'

module Schema
  class Carrier < Normalizers::Instance
    extend Normalizers::Combine
    extend Normalizers::Rename

    params :id, :integer

    rename :company_name, :string, as: :name
    rename :company_city, :string, as: :city
    rename :company_state, :string, as: :state
    rename :company_zip, :string, as: :zip

    combine :company_address_1, :company_address_2, :string, as: :address, sep: ", "

    SCHEMA = Dry::Schema.Params do
      required(:id).filled(:integer)
      required(:name).maybe(:string)

      required(:address).filled(:string)
      required(:city).filled(:string)
      required(:state).filled(:string)
      required(:zip).filled(:string)
    end
  end
end