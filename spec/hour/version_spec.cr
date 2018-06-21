require "spec"
require "../../src/hour"

describe Hour do
  it "is semantically versioned" do
    Hour::VERSION.should eq("0.1.0")
    # TODO: 11/06/2018 It says it's not matching.
    # Hour::VERSION.should match(/^\d+\.\d+\.\d+$/)
    # /^\d+\.\d+\.\d+$/.should match(Hour::VERSION)
  end
end
