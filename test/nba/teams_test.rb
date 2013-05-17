require './test/test_helper'

class TeamsTest < MiniTest::Unit::TestCase
  def test_find_abbr
    abbr = Nba::TEAMS.find_abbr("Jazz")
    assert_equal "UTA", abbr
  end

  def test_find_teamname_by_abbr
    team = Nba::TEAMS.find_teamname_by_abbr("CHI")
    assert_equal "Chicago Bulls", team
  end

  def test_find_alt_abbr
    abbr = Nba::TEAMS.find_alt_abbr("Jazz")
    assert_equal "UTA", abbr
    abbr = Nba::TEAMS.find_alt_abbr("Knicks")
    assert_equal "NY", abbr
  end

  def test_find_teamname_by_alt_abbr
    teamname = Nba::TEAMS.find_teamname_by_alt_abbr("UTA")
    assert_equal "Utah Jazz", teamname
  end
end
