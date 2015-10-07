def calculate_frequency(note, octave)
  f0 = 440 # A4 = 440hz
  a =  1.059463094359
  octaves = octave-4
  steps = note_lookup(note) - note_lookup('a')
  n = octaves*12 + steps

  fn = f0 * a**n
end

# assume # = sharp, b = flat
def note_lookup
  {
    'c' => 0,
    'c#' => 1,
    'db' => 1,
    'd' => 2,
    'd#' => 3,
    'eb' => 3,
    'e' => 4,
    'f' => 5,
    'f#' => 6,
    'gb' => 6,
    'g' => 7,
    'g#' => 8,
    'ab' => 8,
    'a' => 9,
    'a#' => 10,
    'bb' => 10,
    'b' => 11
  }
end

note = ARGV[0] || 'all'
octave = ARGV[1] || 'all'
waveform = ARGV[2] || 'all'

notes = note=='all' ? note_lookup : { note => note_lookup[note]}
octaves = octave=='all' ? [ 0,1,2,3,4,5,6,7,8 ] : [ octave ]
waveforms = waveform=='all' ? ['square', 'sawtooth', 'triangle', 'sine'] : [ waveform ]

octaves.each do |o|
  notes.each do |n|
    waveforms.each do |w|
      filename = "#{n}_#{o}_#{w}.wav"
    end
  end
  puts n
end