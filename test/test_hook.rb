# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'


class TestHook < MiniTest::Test

  def setup
    @ch = CommandHelper.new
    @exe = '../bin/hook'
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("#{@exe}", nil)
    assert_equal "\n", @ch.output
  end
  
  def test_new_line
    @ch.run("#{@exe}", "\n")
    assert_equal "\n", @ch.output
  end
  
  def test_one_line
    @ch.run("#{@exe}", "12345")
    assert_equal "12345\n", @ch.output
  end

  def test_two_lines
    @ch.run("#{@exe}", "123\n45")
    assert_equal "123\n45\n", @ch.output
  end
  
  def test_hooked
    @ch.run("#{@exe} -e ABC", "ABCD\nEFG")
    assert_equal "ABCD--HOOKED--EFG\n", @ch.output
  end
  
  def test_delimiter
    @ch.run("#{@exe} -d=H= -e ABC", "ABCD\nEFG")
    assert_equal "ABCD=H=EFG\n", @ch.output
  end

end

# EOF

