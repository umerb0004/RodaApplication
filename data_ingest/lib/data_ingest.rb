require_relative 'csv_file'

class DataIngest
  attr_reader :filepath, :schema, :store

  def initialize(filepath, schema:, store:)
    @filepath = filepath
    @schema = schema
    @store = store
  end

  def run
    record_enum = CSVFile.new(filepath).lazy.map do |record|
      obj = schema.new(record)

      if obj.errors?
        puts obj.errors
        next
      else
        obj.to_h
      end
    end

    iter = 0
    record_enum.each_slice(1000) do |records|
      persist(records)
      iter += records.count

      puts "Stored #{iter} #{base_classname(schema)} objects"
    end
  end

  private

  def persist(records)
    store.call(records, result: :many)
  end

  def base_classname(klass)
    klass.to_s.split("::").last
  end
end
