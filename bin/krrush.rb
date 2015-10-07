Thread.abort_on_exception=true
OUTPUT_BUFFER_SIZE = 1024.to_f
D3_DATA_IN = "d3data_in.csv"
D3_DATA_OUT = "d3data_out.csv"


require "coreaudio"
require "ruby-audio"
require "oscillator"
require "circular_buffer"$:.unshift "#{File.dirname(__FILE__)}/../lib"

include "reporting"

sin_osc = SineOscillator.new 440
saw_osc = SawtoothOscillator.new 440
tri_osc = TriangleOscillator.new 440
squ_osc = SquareOscillator.new 440
smp_osc = SampleOscillator.new 440, wav: "Juno-60 Unison Saw C0-1.wav", reporting: true

mutex = Mutex.new

out_buffer = CoreAudio.default_output_device.output_buffer(OUTPUT_BUFFER_SIZE)
in_buffer = NArray.sint(Oscillator::BUFFER_SIZE)
circular_buffer = CircularBuffer.new

report_data_start
in_thread = Thread.new do
  loop do
    mutex.synchronize do
      circular_buffer.write_samples smp_osc
    end
  end
end

out_thread = Thread.new do
  loop do
    mutex.synchronize do
      circular_buffer.read_samples out_buffer
    end
  end
end

out_buffer.start

sleep(1)
mutex.lock

report_data_end
