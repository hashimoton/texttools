# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'


class TestHook < MiniTest::Test

  def setup
    @ch = CommandHelper.new
    @exe = '../bin/tt-hook'
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("#{@exe}", nil)
    assert_equal "", @ch.output
  end
  
  def test_new_line
    @ch.run("#{@exe}", "\n")
    assert_equal "\n", @ch.output
  end
  
  def test_one_line
    @ch.run("#{@exe}", "12345")
    assert_equal "12345", @ch.output
  end

  def test_one_line_with_new_line
    @ch.run("#{@exe}", "12345\n")
    assert_equal "12345\n", @ch.output
  end


  def test_two_lines
    @ch.run("#{@exe}", "123\n45")
    assert_equal "123\n45", @ch.output
  end
  
  def test_hooked
    @ch.run("#{@exe} -e ABC", "ABCD\nEFG")
    assert_equal "ABCD--HOOKED--EFG", @ch.output
  end
  
  def test_hooked_with_new_line
    @ch.run("#{@exe} -e ABC", "ABCD\nEFG\nABC\nH\nJKL\n")
    assert_equal "ABCD--HOOKED--EFG\nABC--HOOKED--H--HOOKED--JKL\n", @ch.output
  end
  
  def test_hooked_first_unmatch
    @ch.run("#{@exe} -e ABC", "XYZ\nABCD\nEFG")
    assert_equal "XYZ\nABCD--HOOKED--EFG", @ch.output
  end

  def test_hooked_no_match
    @ch.run("#{@exe} -e A", "XY\n\nZ")
    assert_equal "XY--HOOKED----HOOKED--Z", @ch.output
  end

  def test_unhooked
    @ch.run("#{@exe} -u", "ABCD--HOOKED--EFG\nABC--HOOKED--H--HOOKED--JKL\n")
    assert_equal "ABCD\nEFG\nABC\nH\nJKL\n", @ch.output
  end
  
  def test_unhooked_first_unmatch
    @ch.run("#{@exe} -u", "XYZ\nABCD--HOOKED--EFG")
    assert_equal "XYZ\nABCD\nEFG", @ch.output
  end


  def test_delimiter
    @ch.run("#{@exe} -d=H= -e ABC", "ABCD\nEFG")
    assert_equal "ABCD=H=EFG", @ch.output
  end

end

# EOF

