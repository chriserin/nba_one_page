require './test/test_helper'
require './app/scrape/playbyplay/nbc_description_splitting'

class NbcDescriptionSplittingTest < MiniTest::Unit::TestCase
  def test_split_assist_description
    desc =  "Gerald Wallace makes a layup shot from 2 feet out. C.J. Watson with the assist."
    first, second = TestPlay.new.split_assist_description(desc)
    assert_equal "Gerald Wallace makes a layup shot from 2 feet out.", first
    assert_equal "C.J. Watson with the assist.", second
  end

  def test_split_assist_description_foot_out
    desc =  "Gerald Wallace makes a layup shot from 1 foot out. C.J. Watson with the assist."
    first, second = TestPlay.new.split_assist_description(desc)
    assert_equal "Gerald Wallace makes a layup shot from 1 foot out.", first
    assert_equal "C.J. Watson with the assist.", second
  end

  def test_split_assist_description_no_distance
    desc =  "Gerald Wallace makes a layup shot. C.J. Watson with the assist."
    first, second = TestPlay.new.split_assist_description(desc)
    assert_equal "Gerald Wallace makes a layup shot.", first
    assert_equal "C.J. Watson with the assist.", second
  end

  def test_split_block_description
    desc =  "David West blocks a Raymond Felton jump shot from 4 feet out."
    first, second = TestPlay.new.split_blocks_description(desc)
    assert_equal "David West blocks a", first
    assert_equal "Raymond Felton jump shot from 4 feet out.", second
  end

  def test_split_substitution
    desc = "Substitution: Chris Bosh in for Chris Andersen."
    first, second = TestPlay.new.split_substitution_description(desc)
    assert_equal "Chris Bosh enters game", first
    assert_equal "Chris Andersen exits game", second
  end

  class TestPlay 
    include Scrape::NbcDescriptionSplitting
    def shot_type; "layup shot"; end
  end
end
