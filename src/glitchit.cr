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
  end
end

Commander.run(cli, ARGV)
