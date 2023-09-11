# client_updates_worker.rb
require 'sidekiq'
require 'csv'

require_relative 'repositories/clients'

class ClientUpdatesWorker
  include Sidekiq::Worker
  include RomContainer

  attr_reader :client
  
  def perform(csv_content)
    container = RomContainer::CONTAINER
    @client = ClientRepository.new(container)

    new_records = CSV.parse(csv_content, headers: true)

    validate_and_save_records(new_records)
  end

  private

  def validate_and_save_records(records)
    records.each do |record|
      record = record.to_h

      record = convert_keys(record)

      name = record[:name]
      
      (puts "Invalid record: ID=#{record[:id]}"; next) if name.empty?

      save_record(record)
    end
  end

  def convert_keys(record)
    record.transform_keys { |key| key.downcase.gsub(' ', '_').to_sym }
  end

  def save_record(record)
    client.create_or_update(record)
  end
end
  
