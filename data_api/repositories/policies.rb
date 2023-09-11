require 'rom'
require 'rom-sql'

class Policies < ROM::Relation[:sql]
  schema(:policies, infer: true) do
    associations do
      belongs_to :client, foreign_key: :client_id
      belongs_to :carrier, foreign_key: :carrier_id
    end
  end
end

class PolicyRepository < ROM::Repository[:policies]
  def find(id)
    policies.by_pk(id).one!
  end

  def for_client(client_id)
    policies.where(client_id: client_id)
  end

  def count
    policies.count
  end

end
