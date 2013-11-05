require './test/test_helper.rb'
require './lib/scrape/lineups/sort_plays'

class SortPlaysTest < MiniTest::Unit::TestCase
  include Scrape::Lineups::SortPlays

  def test_sort
    plays = sort_plays(multi_substitution_plays)
    puts plays
  end

  private
  def multi_substitution_plays
    [
      [9, "Shane Battier", true, false],
      [9, "Norris Cole", false, true],
      [9, "Ray Allen", true, false],
      [9, "Udonis Haslem", false, true],
      [9, "Norris Cole", false, false],
      [9, "Michael Carter-Williams", false, false],
      [9, "Norris Cole", true, false],
      [9, "Ray Allen", false, true],
      [9, "Udonis Haslem", true, false],
      [9, "Shane Battier", false, true],
      [9, "Michael Carter-Williams", false, false]
    ].map { |p| TestPlay.new(*p) }
  end

  class TestPlay < Struct.new(:seconds_passed, :player_name, :is_exit?, :is_entrance?)
  end
end
