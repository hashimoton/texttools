# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'

class TestScale < MiniTest::Test

  def setup
    @ch = CommandHelper.new
    @exe = '../bin/tt-sticker'
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("#{@exe}", nil)
    assert_equal "", @ch.output
  end
  
  def test_whole_line
    @ch.run("#{@exe} " + %q{-c 'sed "s/^/[/" | sed "s/$/]/"'}, "1 2 3\n")
    assert_equal "[1 2 3]\n", @ch.output
  end
  
  def test_f1
    @ch.run("#{@exe} " + %q{-f 1 -c 'sed "s/^/[/" | sed "s/$/]/"'}, "1 2 3\n")
    assert_equal "[1] 2 3\n", @ch.output
  end
  
  def test_f2
    @ch.run("#{@exe} " + %q{-f 2 -c 'sed "s/^/[/" | sed "s/$/]/"'}, "1 2 3\n")
    assert_equal "1 [2] 3\n", @ch.output
  end
  
  def test_f3
    @ch.run("#{@exe} " + %q{-f 3 -c 'sed "s/^/[/" | sed "s/$/]/"'}, "1 2 3\n")
    assert_equal "1 2 [3]\n", @ch.output
  end
  

end

# EOF

