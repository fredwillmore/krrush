class Oscillator
  attr_accessor :frequency, :time, :stream_out, :sample_number
  attr_reader :angular_frequency

  BUFFER_SIZE = 1024.to_f
  SAMPLE_RATE = 44100.to_f
  SAMPLE_LENGTH = (1/SAMPLE_RATE).to_f
  PI = 3.14159
  SAMPLE_FILE_DIRECTORY = 'samples/'
  SAMPLE_FILE_SIZE_LIMIT = 12000

  def initialize(frequency, options)
    @time = 0.to_f
    set_frequency frequency || 440
    @report = Report.new options[:report_file] || nil
    unless options[:reporting].nil? || options[:report_file].nil?
      @report.start
    end
  end

  def x
    time % period
  end

  def xpp
    return_value = x
    @time += SAMPLE_LENGTH
    return_value
  end

  def get_samplesNOTUSED(buffer, number_samples)
    if number_samples.nil?
      number_samples = buffer.size
    end
    for i in 0..number_samples-1
      buffer[i] = (get_sample * 0x7FFF).round
      @time = time + SAMPLE_LENGTH
    end
  end

  def shift
    _get_sample
  end

  def set_frequency(frequency)
    @frequency = frequency.to_f
    @angular_frequency = 2*PI*@frequency
  end

  def period
    1/frequency
  end

  private
  def _get_sample
    if @reporting

    end
  end

end

class SineOscillator < Oscillator
  private
  def _get_sample
    super
    Math::sin xpp*angular_frequency
  end
end

class SawtoothOscillator < Oscillator
  private
  def _get_sample
    super
    2*(xpp%period)/period - 1
  end
end

class SquareOscillator < Oscillator
  private
  def _get_sample
    super
    (xpp%period) < period/2 ? -1 : 1
  end
end

class TriangleOscillator < Oscillator
  private
  def _get_sample
    v = 4*x/period
    case xpp
      when 0...period/4
        v
      when period/4...period/2
        2-v
      when period/2...3*period/4
        2-v
      when 3*period/4...period
        v-4
    end
  end
end


class SampleOscillator < Oscillator
  def initialize(frequency, options)
    @ra_sound =  RubyAudio::Sound.open( "#{SAMPLE_FILE_DIRECTORY}#{options[:wav]}").read(:float, SAMPLE_FILE_SIZE_LIMIT)
    super frequency, options
  end

  # TODO: I've named this method period, but now I'm working with samples that cover four duty cycles of the oscillator
  # I'd like to use the whole sampled waveform, so I'm returning a value of 4 times the normal 'period'
  # so now this isn't a period at all - what should I call it?
  def period
    4/frequency
  end

  private

  def _get_sample
    ra_index = (xpp*@ra_sound.real_size/period).floor
    @ra_sound[ra_index]
  end
end