require "minitest/autorun"
require 'dry/schema'

require_relative '../../lib/normalizers/instance'

describe Normalizers::Instance do
  class Normie < Normalizers::Instance
    params :one, :two, :string
  end

  let(:inst) { Normie.new({ one: "one", two: 2, three: "3" }) }

  it "should define param fields" do
    _(inst).must_respond_to :one
    _(inst).must_respond_to :two
    _(inst).wont_respond_to :three

    _(inst.one).must_equal "one"

    _(inst.two).must_be_instance_of String
    _(inst.two).must_equal "2"
  end

  it "can access fields with []" do
    _(inst[:one]).must_equal "one"
    _(inst[:two]).must_equal "2"
  end

  it "introspects fields" do
    _(inst.fields).must_equal [:one, :two]
  end

  it "#to_h" do
    _(inst.to_h).must_equal({one: "one", two: "2"})
  end

  describe "validations" do
    describe "without schema" do
      it "#errors" do
        _(inst.errors).must_equal({})
      end

      it "#errors?" do
        _(inst.errors?).must_equal(false)
      end
    end

    describe "with schema" do
      class NormieNew < Normalizers::Instance
        params :one, :two, :string

        SCHEMA = Dry::Schema.Params do
          required(:one).filled(:string)
          required(:two).maybe(:integer)
        end
      end

      let(:new_inst) { NormieNew.new({ two: 2 }) }

      it "#errors" do
        _(new_inst.errors).must_equal({:one=>["one must be filled"]})
      end

      it "#errors?" do
        _(new_inst.errors?).must_equal(true)
      end
    end
  end
end