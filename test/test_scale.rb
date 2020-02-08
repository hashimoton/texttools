# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require './command_helper.rb'


class TestScale < MiniTest::Test

  def setup
    @ch = CommandHelper.new
  end

  def teardown
    @ch = nil
  end

  def test_empty
    @ch.run("scale", nil)
    assert_equal "", @ch.output
  end
  
  def test_one_line
    @ch.run("scale", "a b c 5")
    assert_equal "a b c +++++ 5\n", @ch.output
  end
  
  def test_field_1
    @ch.run("scale -f 1", "10 a b")
    assert_equal "++++++++++ 10 a b\n", @ch.output
  end
  
  def test_field_2
    @ch.run("scale -f 2", "a 3 b")
    assert_equal "a +++ 3 b\n", @ch.output
  end

  def test_delimiter
    @ch.run("scale -d, -f 2", "a,3,x\nb,10,y")
    assert_equal "a,+++,3,x\nb,++++++++++,10,y\n", @ch.output
  end
  
  def test_multiplier_2
    @ch.run("scale -m 2", "3")
    assert_equal "++++++ 3\n", @ch.output
  end
  
  def test_multiplier_02
    @ch.run("scale -m 0.2", "15")
    assert_equal "+++\ 15\n", @ch.output
  end



end

# EOF

