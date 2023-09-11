require 'rom'
require 'rom-sql'

class Policies < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :client, foreign_key: :client_id
      belongs_to :carrier, foreign_key: :carrier_id
    end
  end
end
