require 'csv'

class CSVFile
  include Enumerable

  def initialize(path)
    @path = path
  end

  def each &block
    CSV.open(@path, "rb", headers: true, header_converters: :symbol ) .each {|row| yield row.to_h }
  end
end