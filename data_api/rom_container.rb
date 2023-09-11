require 'rom-sql'

require_relative 'repositories/clients'
require_relative 'repositories/carriers'
require_relative 'repositories/policies'

module RomContainer
  CONTAINER = ROM.container(:sql, "sqlite://../data/database.db") do |conf|
    conf.register_relation(Clients)
    conf.register_relation(Carriers)
    conf.register_relation(Policies)
  end
end