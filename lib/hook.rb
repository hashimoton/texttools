#! /usr/bin/env ruby
# coding: utf-8
# Continue lines if the following line contains the give pattern.

require "optparse"

class HookCommand

  DEFAULT_DELIMITER = '--HOOKED--'
  
  def initialize()
  end

  def opt_parse(argv)
    opts = {}
    
    OptionParser.new do |opt|
      begin
        opt.version = '0.1.0'
        opt.banner += " FILE [FILE...]"
        opt.separator("\nOptions:")
        
        opt.on('-d=DELIMITER',
          "Delimiter(#{DEFAULT_DELIMITER})") {|v| opts[:d] = v}
        opt.on('-e=REGEX',
          "Pattern") {|v| opts[:e] = v}
        opt.on('-v',
          "Invert match") {|v| opts[:v] = v}
        
        opt.parse!(ARGV)
      rescue => e
        $stderr.puts "ERROR: #{e}.\n#{opt}"
        exit 1
      end
    end
    
    return opts
  end
  
  def hook?(line)
    return @is_invert ? (line =~ @pattern) : (line !~ @pattern)
  end
  
  def hook
    line = ""
    prev_line = ""
    line_count = 0
    
    ARGF.each_line do |line|
      print prev_line
      line.chomp!
      if hook?(line)
        print @delimiter
      else
        if line_count > 0
          puts ""
        end
      end
      
      prev_line = line
      line_count += 1
    end
    
    puts prev_line
  end
    
  def main(argv)
    opts = opt_parse(argv)
    @delimiter = opts[:d]
    if @delimiter.nil?
      @delimiter = DEFAULT_DELIMITER
    end
    
    if opts[:e].nil?
      @pattern = Regexp.new("")
    else
      @pattern = Regexp.new(opts[:e])
    end
    
    @is_invert = opts[:v]
    
    hook
    
  end # main

end # class


################################

Encoding.default_external = 'utf-8'
HookCommand.new.main(ARGV)

exit 0

# EOF