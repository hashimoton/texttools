#! /usr/bin/env ruby
# coding: utf-8
# Split a file into pieces determined by a function

require "optparse"


class WedgeCommand

  DEFAULT_BFUNC = "false"
  DEFAULT_MARKER = "--WEDGE--"

  def initialize()
  end


  def opt_parse(argv)
    opts = {}
    
    OptionParser.new do |opt|
      begin
        opt.version = '0.1.1'
        opt.banner += " FILE [FILE...]"
        opt.separator("\nOptions:")
        
        opt.on('-b=FUNCTION',
          'A function of line. Returns true at each breakpoint (default = false)') {|v| opts[:b] = v}
        opt.on('-m=MARKER',
          'Break point marker (default = --WEDGE--)') {|v| opts[:m] = v}
        opt.on('-o=PREFIX',
          'Output goes to files instead of STDOUT. ') {|v| opts[:o] = v}
        opt.parse!(ARGV)
      rescue => e
        $stderr.puts "ERROR: #{e}.\n#{opt}"
        exit 1
      end
    end
    
    return opts
  end


  def breakpoint_function(script)
    bfunc = eval <<-EOS
      lambda do |line|
        result = #{script}
        return result
      end
    EOS
  end


  def main(argv)
    opts = opt_parse(argv)
    bfunc = breakpoint_function(opts[:b].nil? ? DEFAULT_BFUNC : opts[:b])
    marker = opts[:m].nil? ? DEFAULT_MARKER : opts[:m]
    is_filter = opts[:o].nil?
    
    if !is_filter
      prefix = opts[:o]
      fcount = 0
      ofile = File.open("#{prefix}_#{fcount}", "w")
      lcount = 0
    end
    
    ARGF.each_line do |line|
      if bfunc.call(line)
        if is_filter
          puts marker
        elsif lcount > 0
          ofile.flush
          ofile.close
          fcount += 1
          ofile = File.open("#{prefix}_#{fcount}", "w")
          lcount = 0
        end
      end

      if is_filter
        puts line
      else
        ofile.puts line
        lcount += 1
      end
    end
    
  end # main

end # class


################################

Encoding.default_external = 'utf-8'
WedgeCommand.new.main(ARGV)

exit 0

# EOF
