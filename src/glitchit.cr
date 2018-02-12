require "commander"

cli = Commander::Command.new do |cmd|
  cmd.use = "glitchit"
  cmd.long = "glitchit jpg image glitcher on crystal."

  cmd.flags.add do |flag|
    flag.name = "input"
    flag.short = "-i"
    flag.long = "--input"
    flag.default = ""
    flag.description = "Input jpg image to be glitched."
  end

  cmd.flags.add do |flag|
    flag.name = "output"
    flag.short = "-o"
    flag.long = "--output"
    flag.default = "glitched.jpg"
    flag.description = "Glitched output jpg image."
  end

  cmd.flags.add do |flag|
    flag.name = "bytes"
    flag.short = "-b"
    flag.long = "--bytes"
    flag.default = 20
    flag.description = "Bytes to replace with random chars."
  end

  cmd.flags.add do |flag|
    flag.name = "times"
    flag.short = "-t"
    flag.long = "--times"
    flag.default = 5
    flag.description = "Number of times to insert glitch."
  end

  cmd.flags.add do |flag|
    flag.name = "start"
    flag.short = "-s"
    flag.long = "--start"
    flag.default = 0
    flag.description = "Where on the file to start glitching (can be %)."
  end

  cmd.flags.add do |flag|
    flag.name = "finish"
    flag.short = "-f"
    flag.long = "--finish"
    flag.default = 1
    flag.description = "Where on the file to stop glitching (can be %)."
  end

  cmd.run do |options, arguments|
    in_file = options.string["input"]   # => ""
    out_file = options.string["output"] # => "glitched.jpg"
    bytes = options.int["bytes"]        # => 20
    times = options.int["times"]        # => 5
    start = options.int["start"]        # => 0
    finish = options.int["finish"]      # => 1
    arguments                           # => Array(String)
    abort cmd.help if in_file.blank?

    Glitcher.new(in_file, out_file, bytes, times, start, finish).glitchit
  end
end

Commander.run(cli, ARGV)

class Glitcher
  def initialize(@input_file : String,
                 @output_file : String = "glitched.jpg",
                 @bytes : (Int32 | Int64) = 20,
                 @times : (Int32 | Int64) = 5,
                 @start : (Int32 | Int64) = 0,
                 @finish : (Int32 | Int64) = 1)
    abort "input file must be jpg" unless input_file.ends_with?("jpg")
    @total_bytes = Int32.new(File.size(@input_file))
    @header_size = Int32.new(2000)
  end

  def glitchit
    output = File.new(@output_file, "w")

    File.open(@input_file) do |file|
      count = 0

      bytes_to_shift = generate_array_of_safe_bytes

      file.each_byte do |byte|
        while count < @header_size
          count += 1
          next
        end

        if bytes_to_shift.includes?(count)
          output.write_byte(byte.succ)
        else
          output.write_byte(byte)
        end

        count += 1
      end
    end
  end

  # Generate an array of bytes outside of header to glitch
  # TODO: Find a better way to determine if safe bytes (we are guessing after 2000 atm)
  def generate_array_of_safe_bytes
    bytes_to_shift = Array(Int32).new
    @times.times do
      bytes_to_shift << rand(@header_size...@total_bytes)
      bytes_to_shift.sort!
    end
    bytes_to_shift
  end
end
