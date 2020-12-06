# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'


class TestWedge < MiniTest::Test

  def setup
    @ch = CommandHelper.new
    @exe = '../bin/tt-wedge'
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("#{@exe}", "")
    assert_equal "", @ch.output
  end
  
  
  def test_marker
    @ch.run("#{@exe} -m=W= -b 'line.start_with?(\"a\")'", "ABC\nabc\n123\n456\naaa\n")
    assert_equal "ABC\n=W=\nabc\n123\n456\n=W=\naaa\n", @ch.output
  end

end

# EOF

