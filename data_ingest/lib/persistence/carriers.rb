require 'rom'
require 'rom-sql'

class Carriers < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :policies
    end
  end
end
