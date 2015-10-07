class Envelope
  attr_accessor :attack, :decay, :sustain, :release
  attr_reader :released

  def numeric_positive(arg)
    arg.is_a?(Numeric) && arg>=0
  end

  def initialize(attack=0, decay=0, sustain=0, release=0)
    raise ArgumentError.new("Attack must be a positive number foo") unless numeric_positive attack
    raise ArgumentError.new("Decay must be a positive number") unless numeric_positive decay
    raise ArgumentError.new("Sustain must be a number from 0 to 1") unless (0..1).include? sustain
    raise ArgumentError.new("Release must be a positive number") unless numeric_positive release

    @attack = attack
    @decay = decay
    @sustain = sustain
    @release = release
    @release_time = 0
    @released = false
    @release_level = 0
    @level = 0
  end

  def released?
    released
  end

  def f(t)
    case t
      when 0...attack
        t/attack
      when attack...(attack+decay)
        # sustain + (1-sustain)*(t-attack)/decay
        1.0 + (sustain-1.0)*(t-attack)/decay
      when (attack+decay)..Float::INFINITY
        if released?
          sustain - (sustain/release) * (t - @release_time)
        else
          sustain
        end
    end
  end

  def release!(t)
    unless @released
      @release_time = t<attack+decay ? attack+decay : t
      @released = true
    end
  end

end