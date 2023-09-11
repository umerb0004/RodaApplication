require 'rom'
require 'rom-sql'

class Clients < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :policies
    end
  end
end
