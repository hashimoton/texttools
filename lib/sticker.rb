#! /usr/bin/env ruby
# coding: utf-8
# Overwrite fields

require "optparse"
require "open3"

class StickerCommand
  
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
          'Delimiter(" ")') {|v| opts[:d] = v}
        opt.on('-f=NUMBER,NUMBER,...',
          "Field base 1 (whole line)") {|v| opts[:f] = v}
        opt.on('-c=COMMAND',
          "Filter command (cat)") {|v| opts[:c] = v}
        
        opt.order!(argv)
      rescue => e
        $stderr.puts "ERROR: #{e}.\n#{opt}"
        exit 1
      end
    end
    
    return opts
  end


  def main(argv)
    opts = opt_parse(argv)
    @delimiter = opts[:d] || " "
    @field_index = opts[:f] ? opts[:f].to_i - 1 : nil
    @command = opts[:c] || "cat"
    
    ARGF.each_line do |line|
      line.chomp!
      fields = line.split(@delimiter);
      if @field_index.nil?
        raw_value = line
      else
        raw_value = fields[@field_index]
      end
      
      output, error, status = Open3.capture3(@command, stdin_data: raw_value)
      if !error.nil? && !error.empty?
        $stderr.puts "ERROR: #{error}"
      end
      
      if @field_index.nil?
         replaced = output.chomp
      else
        fields[@field_index] = output.chomp
        replaced = fields.join(@delimiter)
      end
      
      puts replaced
    end
    
  end # main

end # class


################################

Encoding.default_external = 'utf-8'
StickerCommand.new.main(ARGV)

exit 0

# EOF
