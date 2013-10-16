require './test/test_helper'

class StretchesListTest < MiniTest::Unit::TestCase
  def test_init
    list = Nba::StretchesList.new([])
    refute_nil list
  end

  def test_compress_lines
    lines = [OpenStruct.new(start: 0, end: 20), OpenStruct.new(start: 20, end: 40)]
    list = Nba::StretchesList.new(lines)
    stints = list.compress_stretches
    assert_equal 1, stints.length
  end

  def test_compress_unconnected_stretches
    lines = [OpenStruct.new(start: 0, end: 20), OpenStruct.new(start: 30, end: 40)]
    list = Nba::StretchesList.new(lines)
    stints = list.compress_stretches
    assert_equal 2, stints.length
  end
end
