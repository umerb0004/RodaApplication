require "minitest/autorun"

require_relative '../../lib/normalizers/instance'
require_relative '../../lib/normalizers/combine'

describe Normalizers::Combine do
  class NormieCombine < Normalizers::Instance
    extend Normalizers::Combine

    combine :field_1, :field_2, :string, as: :my_field
    combine :field_1, :field_2, :string, as: :new_field, sep: ", "
  end

  let(:inst) { NormieCombine.new({field_1: "one", field_2: "two"}) }

  it "should allow defining fields for combination" do

    _(inst).must_respond_to :my_field
    _(inst).wont_respond_to :field_1
    _(inst).wont_respond_to :field_2

    _(inst.my_field).must_equal "onetwo"
  end

  it "can define the separator" do
    _(inst.new_field).must_equal "one, two"
  end
end
