# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'


class TestHook < MiniTest::Test

  def setup
    @ch = CommandHelper.new
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("hook", nil)
    assert_equal "\n", @ch.output
  end
  
  def test_new_line
    @ch.run("hook", "\n")
    assert_equal "\n", @ch.output
  end
  
  def test_one_line
    @ch.run("hook", "12345")
    assert_equal "12345\n", @ch.output
  end

  def test_two_lines
    @ch.run("hook", "123\n45")
    assert_equal "123\n45\n", @ch.output
  end
  
  def test_hooked
    @ch.run("hook -e ABC", "ABCD\nEFG")
    assert_equal "ABCD--HOOKED--EFG\n", @ch.output
  end
  
  def test_delimiter
    @ch.run("hook -d=H= -e ABC", "ABCD\nEFG")
    assert_equal "ABCD=H=EFG\n", @ch.output
  end


end

# EOF

