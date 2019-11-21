#! /usr/bin/env ruby
# coding: utf-8
# Aggregate values for each key.

require "optparse"
require "keybreak"

class BandCommand

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
          "Delimiter(spaces)") {|v| opts[:d] = v}
        opt.on('-c=COMMAND',
          "Command for values (values.size)") {|v| opts[:c] = v}
        
        opt.parse!(ARGV)
      rescue => e
        $stderr.puts "ERROR: #{e}.\n#{opt}"
        exit 1
      end
    end
    
    return opts
  end
  
  
  def array_function(command)
    afunc = eval <<-EOS
      lambda do |values|
        result = #{command}
        return result
      end
    EOS
  end
  
  
  def main(argv)
    opts = opt_parse(argv)
    delimiter = opts[:d]
    if delimiter.nil?
      delimiter = " "
    end
    
    if opts[:c].nil?
      command = "values.size"
    else
      command = opts[:c]
    end
    
    afunc = array_function(command)
    
    Keybreak.execute_with_controller do |c, values|
      c.on(:keystart) {values = []}
      c.on(:keyend) {|key| puts "#{key}#{delimiter}#{afunc.call(values)}"}
      
      ARGF.each_line do |line|
        key, value = line.chomp.split(delimiter)
        c.feed(key)
        values.push(value)
      end
    end
  
  end # main

end # class


################################

Encoding.default_external = 'utf-8'
BandCommand.new.main(ARGV)

exit 0

# EOF
