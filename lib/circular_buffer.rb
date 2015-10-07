# TODO: it's been pointed out to me that users of this buffer have no business knowing the implementation details of the buffer
# therefore, I should change the name to just Buffer

def dputs output
  if $report_index < REPORT_DATA_LIMIT
    puts output
  end
end

class CircularBuffer
  BUFFER_SIZE = 4096
  DEBUGGING = true

  attr_accessor :read_index, :write_index, :empty # do I even want/need these available publicly?

  def initialize(type)
    @read_index = @write_index = 0
    @empty = true
    @buffer = type BUFFER_SIZE
  end

  def index_diff
    @write_index-@read_index
  end

  def samples_available_to_read
    case @empty
      when true
        0
      when false
        index_diff % BUFFER_SIZE > 0 ? index_diff % BUFFER_SIZE : BUFFER_SIZE
    end
  end

  def samples_available_to_write
    @empty ? BUFFER_SIZE : -index_diff % BUFFER_SIZE
  end

  def read_samples(sink, num_samples=nil)
    num_samples = samples_available_to_read if num_samples.nil? || num_samples > samples_available_to_read
    if num_samples > 0
      outarray = Array.new num_samples if DEBUGGING
      num_samples.times do |i|
        s = @buffer[ripp]
        outarray[i] = s if DEBUGGING
        sink << (s * 0x7FFF).round
      end
      if index_diff==0
        @empty=true
      end
      report_data(D3_DATA_IN, outarray) if DEBUGGING
    end
  end

  def write_samples(source, num_samples=nil)
    num_samples = samples_available_to_write if num_samples.nil? || num_samples > samples_available_to_write
    outarray = Array.new num_samples if DEBUGGING
    num_samples.times do |i|
      s = source.shift
      outarray[i] = s if DEBUGGING
      @buffer[wipp] = s
      @empty=false
    end
    report_data(D3_DATA_OUT, outarray) if DEBUGGING
  end

  def empty?
    empty
  end

  protected

  def ripp
    return_value = @read_index
    @read_index += 1
    @read_index %= BUFFER_SIZE
    return_value
  end

  def wipp
    return_value = @write_index
    @write_index += 1
    @write_index %= BUFFER_SIZE
    return_value
  end

end
