#! /usr/bin/env ruby
# coding: utf-8
# Visualize the magunitude of number.

require "optparse"

class ScaleCommand
  
  def initialize()
  end

  def opt_parse(argv)
    opts = {}
    
    OptionParser.new do |opt|
      begin
        opt.version = '0.1.1'
        opt.banner += " FILE [FILE...]"
        opt.separator("\nOptions:")
        
        opt.on('-d=DELIMITER',
          'Delimiter(" ")') {|v| opts[:d] = v}
        opt.on('-f=NUMBER',
          "Field base 1 (0 = the last field)") {|v| opts[:f] = v}
        opt.on('-m=NUMBER',
          "Multiplier(1.0)") {|v| opts[:m] = v}
        
        opt.parse!(ARGV)
      rescue => e
        $stderr.puts "ERROR: #{e}.\n#{opt}"
        exit 1
      end
    end
    
    return opts
  end


  def main(argv)
    opts = opt_parse(argv)
    @delimiter = opts[:d] ? opts[:d] : " "
    @field_index = opts[:f] ? opts[:f].to_i - 1 : -1
    
    @multiplier = opts[:m] ? opts[:m].to_f : 1.0

    
    ARGF.each_line do |line|
      line.chomp!
      fields = line.split(@delimiter);
      raw_value = fields[@field_index]
      value = (@multiplier * fields[@field_index].to_f).round
      if value < 0
        symbol = "-"
        value = - value
      else
        symbol = "+"
      end
      fields[@field_index] = "#{symbol * value}#{@delimiter}#{raw_value}"
      puts fields.join(@delimiter)
    end
    
  end # main

end # class


################################

Encoding.default_external = 'utf-8'
ScaleCommand.new.main(ARGV)

exit 0

# EOF
