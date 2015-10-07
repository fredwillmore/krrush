require 'minitest/spec'
require 'minitest/autorun'

describe Oscillator do
  it "can be created with no arguments" do
    Oscillator.new.must_be_instance_of Oscillator
  end

  it "should throw error with bad arguments" do
    # Array.new.must_be_instance_of Array
  end
end
