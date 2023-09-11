require "minitest/autorun"

require_relative '../lib/csv_file'

describe CSVFile do
  let(:reader) { CSVFile.new("../data/Clients.csv") }

  before do
    @store = reader.collect
  end

  describe "file reading" do
    it "should read a file" do
      _(@store.count).must_equal 5000
    end

    it "should downcase headers" do
      _(@store.first.keys[1]).must_equal :name
    end

    it "should snakecase spaced headers" do
      _(@store.first.keys[6]).must_equal :major_group
    end
  end
end
