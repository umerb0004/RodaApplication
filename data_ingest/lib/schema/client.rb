require 'dry/schema'
require_relative '../normalizers/instance'

module Schema
  class Client < Normalizers::Instance
    params :id, :integer

    params :name, :description,
           :address, :city, :state,
           :division, :string

    params :industry_group, :major_group, :sic, :float

    SCHEMA = Dry::Schema.Params do
      required(:id).filled(:integer)
      required(:name).maybe(:string)
      required(:description).maybe(:string)

      required(:address).maybe(:string)
      required(:city).maybe(:string)
      required(:state).maybe(:string)

      required(:division).maybe(:string)
      required(:industry_group).maybe(:float)
      required(:major_group).maybe(:float)
      required(:sic).maybe(:float)
    end
  end
end
