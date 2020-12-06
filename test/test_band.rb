# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'


class TestBand < MiniTest::Test

  def setup
    @ch = CommandHelper.new
    @exe = '../bin/tt-band'
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("#{@exe}", "")
    assert_equal "", @ch.output
  end
 
  def test_count
    @ch.run("#{@exe}", "a\na\nb\nc\nc\nc\n")
    assert_equal "a 2\nb 1\nc 3\n", @ch.output
  end
  
  def test_command
    @ch.run("#{@exe} -c 'values.join(\"-\")'", "a 1\na 2\nb 1\nc 1\nc 2\nc 3\n")
    assert_equal "a 1-2\nb 1\nc 1-2-3\n", @ch.output
  end
  
  def test_delimiter
    @ch.run("#{@exe} -d,", "a,1\na,2\nb,1\nc,1\nc,2\nc,3\n")
    assert_equal "a,2\nb,1\nc,3\n", @ch.output
  end

end

# EOF

