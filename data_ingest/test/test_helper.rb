require 'minitest/autorun'
require 'csv'

def parse_single(data)
  CSV.parse(data, headers: true, header_converters: :symbol).first.to_h
end
