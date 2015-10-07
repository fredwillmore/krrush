$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'minitest/spec'
require 'minitest/autorun'
require 'envelope'

describe 'Envelope' do

  it "can be created with no arguments" do
    Envelope.new.must_be_instance_of Envelope
  end

  it "should throw error with bad arguments" do
    ['bad', -1].each do |arg|
      proc { Envelope.new(arg) }.must_raise ArgumentError
      proc { Envelope.new(0,arg) }.must_raise ArgumentError
      proc { Envelope.new(0,0,arg) }.must_raise ArgumentError
      proc { Envelope.new(0,0,0,arg) }.must_raise ArgumentError
    end
  end
end

describe 'Test Values' do
  def setup
    @a, @d, @s, @r = 0.1, 0.2, 0.5, 0.3
    @env = Envelope.new @a, @d, @s, @r
    @denominator = rand(1..10) + 0.0 # I think the random values are a good idea, but what about repeatability?
  end


  it "should always give a value between 0 and 1" do
    (0..1).must_include @env.f(rand 1000)
  end

  it "should return correct value in attack phase" do
    @env.f(@a/@denominator).must_be_close_to 1.0/@denominator
  end

  it "should return correct value in decay phase" do
    @env.f(@a + @d/@denominator).must_be_close_to 1.0-(1.0-@s)/@denominator
  end

  it "should return correct sustain value" do
    @env.f(@a+@d).must_equal @s
  end

  it "should return correct value in release phase" do
    time = @a+@d + 5/@denominator
    release_time = time/2 < @a+@d ? @a+@d : time/2
    @env.release! release_time
    @env.f(time).must_equal @s-(@s/@r)*(time-release_time)
  end

end