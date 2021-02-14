# coding: utf-8

require "open3"

Encoding.default_external = 'utf-8'

class CommandHelper

  attr_accessor :output, :error, :exit_code
  
  def run(command, input)
    @output, @error, status = Open3.capture3(command, stdin_data: input)
    $stderr.puts @error
    @exit_code = status.to_i
  end
  
end


# EOF

