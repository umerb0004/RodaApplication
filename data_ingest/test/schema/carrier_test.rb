require_relative "../test_helper"


require_relative '../../lib/schema/carrier'

describe Schema::Carrier do
  describe "with data normalizer" do
    let(:data_one) { parse_single("Id,Company Name,Company Address 1,Company Address 2,Company City,Company State,Company Zip\n0,Bankers Standard Insurance Company,PO Box 1000,,Philadelphia,PA,19106") }
    let(:data_two) { parse_single("Id,Company Name,Company Address 1,Company Address 2,Company City,Company State,Company Zip\n40,Sompo America Fire & Marine Insurance Company,11405 North Community House Rd.,Suite 600,Charlotte,NC,28277") }
    let(:data_bad) { parse_single("Id,Company Name,Company Address 1,Company Address 2,Company City,Company State,Company Zip\n40,Sompo America Fire & Marine Insurance Company,11405 North Community House Rd.,Suite 600,Charlotte") }

    it "should normalize data" do
      carrier = Schema::Carrier.new(data_one)

      _(carrier).must_be_instance_of(Schema::Carrier)
      _(carrier.to_h).must_equal({ id: 0, name: "Bankers Standard Insurance Company", address: "PO Box 1000", city: "Philadelphia", state: "PA", zip: "19106" })
      _(carrier.errors).must_be_empty
    end

    it "should allow for empty address fields" do
      carrier = Schema::Carrier.new(data_two)

      _(carrier.to_h).must_equal({ id: 40, name: "Sompo America Fire & Marine Insurance Company", address: "11405 North Community House Rd., Suite 600", city: "Charlotte", state: "NC", zip: "28277" })
      _(carrier.errors).must_be_empty
    end

    it "error if missing required field" do
      carrier = Schema::Carrier.new(data_bad)

      _(carrier.errors.keys).must_equal([:state, :zip])
    end
  end
end