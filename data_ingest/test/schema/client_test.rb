require_relative "../test_helper"

require_relative '../../lib/schema/client'

describe Schema::Client do
  describe "without normalizer" do
    let(:data) { parse_single("Id,Name,Address,City,State,Division,Major Group,Industry Group,SIC,Description\n1,Robinson and Sons,37898 Rollins Port Suite 901,New Emilyton,North Carolina,D,20.0,205.0,2052.0,Cookies and Crackers") }

    it "should simply present data" do
      client = Schema::Client.new(data)

      _(client).must_be_instance_of(Schema::Client)
      _(client.errors).must_be_empty
    end
  end
end