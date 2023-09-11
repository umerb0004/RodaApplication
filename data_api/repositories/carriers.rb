require 'rom'
require 'rom-sql'

class Carriers < ROM::Relation[:sql]
  schema(:carriers, infer: true) do
    associations do
      has_many :policies
    end
  end
end

class CarrierRepository < ROM::Repository[:carriers]
  def count
    carriers.count
  end
end
