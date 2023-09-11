#!/usr/bin/env ruby

require 'bundler/setup'
require 'rom-sql'

require_relative '../lib/data_ingest'

require_relative '../lib/persistence/policies'
require_relative '../lib/persistence/carriers'
require_relative '../lib/persistence/clients'

require_relative '../lib/schema/policy'
require_relative '../lib/schema/carrier'
require_relative '../lib/schema/client'

rom = ROM.container(:sql, 'sqlite://../data/database.db') do |conf|
  conf.register_relation(Clients)
  conf.register_relation(Carriers)
  conf.register_relation(Policies)
end

workflow = {
  clients: Schema::Client,
  carriers: Schema::Carrier,
  policies: Schema::Policy
}

workflow.each do |type, schema|
  path = "../data/#{type.capitalize}.csv"
  command = rom.relations[type].command(:create)
  worker = DataIngest.new(path, schema: schema, store: command)

  worker.run
end
