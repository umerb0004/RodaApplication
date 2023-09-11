require_relative "../test_helper"

require_relative '../../lib/normalizers/instance'
require_relative '../../lib/normalizers/rename'

describe Normalizers::Rename do
  class NormieName < Normalizers::Instance
    extend Normalizers::Rename

    rename :this, :string, as: :that
  end

  let(:inst) { NormieName.new(this: "bingo")}

  it "should rename fields" do
    _(inst).must_respond_to(:that)
    _(inst).wont_respond_to(:this)

    _(inst.that).must_equal "bingo"
  end
end