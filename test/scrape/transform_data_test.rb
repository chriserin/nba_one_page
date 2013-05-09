require './test/test_helper'
require './app/scrape/boxscore/transform_boxscore_data'
require './app/scrape/boxscore/nba_boxscore_scraper'

class TransformBoxscoreDataTest < MiniTest::Unit::TestCase
  def setup_scraped_boxscore

    VCR.use_cassette('boxscore') do
      scraper = NbaBoxscoreScraper.new nil
      @args_from_scraper = scraper.scrape("http://scores.espn.go.com/nba/boxscore?gameId=320127004")
#STARTERS	MIN	FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	+/-	PTS
#Carlos Delfino, SG	13	0-4	0-0	0-0	0	1	1	0	0	0	0	1	-13	0
#Luc Richard Mbah a Moute, PF	12	2-5	0-0	0-0	0	0	0	0	0	0	1	1	-6	4
#Drew Gooden, PF	36	6-14	1-2	10-10	6	9	15	6	0	1	4	2	+1	23
#Shaun Livingston, PG	21	3-5	0-0	0-0	2	2	4	2	1	0	0	0	-11	6
#Brandon Jennings, PG	37	10-22	4-11	1-1	1	6	7	3	2	0	4	3	-1	25
#BENCH	MIN	FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	+/-	PTS
#Stephen Jackson, SF	35	4-14	1-6	1-1	0	4	4	5	0	0	2	3	+6	10
#Mike Dunleavy, SF	19	1-5	0-3	2-2	1	1	2	0	0	0	1	1	-4	4
#Beno Udrih, PG	19	1-5	0-1	0-0	0	0	0	4	1	0	1	0	+1	2
#Ersan Ilyasova, SF	10	3-4	0-0	1-2	2	2	4	0	0	0	1	4	-2	7
#Jon Leuer, PF	20	9-11	1-1	0-0	1	4	5	0	0	0	0	3	0	19
#Larry Sanders, C	12	0-1	0-0	0-0	1	0	1	2	0	1	1	1	-8	0
#Tobias Harris, SF	7	0-2	0-0	0-0	0	0	0	0	0	0	0	0	+2	0
#Jon Brockman, PF	DNP COACH'S DECISION
#TOTALS		FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	 	PTS
#39-92	7-24	15-16	14	29	43	22	4	2	15	19	 	100
#42.4%	29.2%	93.8%	
#Fast break points:   8
#Points in the paint:   42
#Team TO ( points off ):   15 (23)+/- denotes team's net points while the player is on the court.
#Chicago Bulls
#STARTERS	MIN	FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	+/-	PTS
#Carlos Boozer, PF	41	8-15	0-0	4-6	5	8	13	1	1	2	2	4	+5	20
#Ronnie Brewer, SF	43	2-13	0-3	4-5	1	3	4	6	0	1	1	0	0	8
#Joakim Noah, C	34	6-10	0-0	3-6	8	8	16	4	3	3	0	3	+2	15
#Kyle Korver, SF	36	3-9	2-6	1-2	0	3	3	1	0	0	1	2	+16	9
#Derrick Rose, PG	37	14-24	0-2	6-10	1	2	3	3	0	1	3	2	+8	34
#BENCH	MIN	FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	+/-	PTS
#Taj Gibson, PF	15	1-4	0-0	0-2	2	2	4	0	0	2	0	1	+6	2
#C.J. Watson, PG	18	5-11	3-6	0-0	0	1	1	2	0	0	0	2	-1	13
#Omer Asik, C	6	2-2	0-0	0-0	2	3	5	1	0	0	1	1	+1	4
#Jimmy Butler, SF	9	0-2	0-0	2-2	1	0	1	0	1	0	0	2	-2	2
#Richard Hamilton, SG	DNP COACH'S DECISION
#Brian Scalabrine, PF	DNP COACH'S DECISION
#Mike James, PG	DNP COACH'S DECISION
#John Lucas, PG	DNP COACH'S DECISION
#TOTALS		FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	 	PTS
#41-90	5-17	20-33	20	30	50	18	5	9	8	17	 	107
#45.6%	29.4%	60.6%	
    end

    LineTypeFactory.get_line_type("2013", :game_line)
  end

  def test_transform
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)

    refute_nil home.total
    refute_nil home.opponent_total
    refute_nil home.player_lines
    refute_nil home.bench_total
    refute_nil home.starters_total

    refute_nil away.total
    refute_nil away.opponent_total
    refute_nil away.player_lines
    refute_nil away.bench_total
    refute_nil away.starters_total
  end

  def test_transform_home_total
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = home.total.to_hash
    assert hash[:made_field_goals] == "41", "needed 41, was #{hash[:made_field_goals]}"
    assert hash[:attempted_field_goals] == "90", "needed 90, was #{hash[:attempted_field_goals]}"
    assert hash[:made_threes] == "5", "needed 5, was #{hash[:made_threes]}"
    assert hash[:attempted_threes] == "17", "needed 17, was #{hash[:attempted_threes]}"
    assert hash[:made_free_throws] == "20", "needed 20, was #{hash[:made_free_throws]}"
    assert hash[:attempted_free_throws] == "33", "needed 33, was #{hash[:attempted_free_throws]}"
    assert hash[:offensive_rebounds] == "20", "needed 20, was #{hash[:offensive_rebounds]}"
    assert hash[:defensive_rebounds] == "30", "needed 30, was #{hash[:defensive_rebounds]}"
    assert hash[:total_rebounds] == "50", "needed 50, was #{hash[:total_rebounds]}"
    assert hash[:assists] == "18", "needed 18, was #{hash[:assists]}"
    assert hash[:steals] == "5", "needed 5, was #{hash[:steals]}"
    assert hash[:blocks] == "9", "needed 9, was #{hash[:blocks]}"
    assert hash[:turnovers] == 10, "needed 10, was #{hash[:turnovers]}"
    assert hash[:personal_fouls] == "17", "needed 17, was #{hash[:personal_fouls]}"
    assert hash[:points] == "107", "needed 107, was #{hash[:points]}"
    assert hash[:team] == "Chicago Bulls", "needed Chicago Bulls, was #{hash[:team]}"
    assert hash[:is_opponent_total] == false
  end

  def test_transform_home_opponent_total
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = away.opponent_total.to_hash
    assert hash[:made_field_goals] == "41", "needed 41, was #{hash[:made_field_goals]}"
    assert hash[:attempted_field_goals] == "90", "needed 90, was #{hash[:attempted_field_goals]}"
    assert hash[:made_threes] == "5", "needed 5, was #{hash[:made_threes]}"
    assert hash[:attempted_threes] == "17", "needed 17, was #{hash[:attempted_threes]}"
    assert hash[:made_free_throws] == "20", "needed 20, was #{hash[:made_free_throws]}"
    assert hash[:attempted_free_throws] == "33", "needed 33, was #{hash[:attempted_free_throws]}"
    assert hash[:offensive_rebounds] == "20", "needed 20, was #{hash[:offensive_rebounds]}"
    assert hash[:defensive_rebounds] == "30", "needed 30, was #{hash[:defensive_rebounds]}"
    assert hash[:total_rebounds] == "50", "needed 50, was #{hash[:total_rebounds]}"
    assert hash[:assists] == "18", "needed 18, was #{hash[:assists]}"
    assert hash[:steals] == "5", "needed 5, was #{hash[:steals]}"
    assert hash[:blocks] == "9", "needed 9, was #{hash[:blocks]}"
    assert hash[:turnovers] == 10, "needed 10, was #{hash[:turnovers]}"
    assert hash[:personal_fouls] == "17", "needed 17, was #{hash[:personal_fouls]}"
    assert hash[:points] == "107", "needed 107, was #{hash[:points]}"
    assert hash[:is_opponent_total] == true
  end

  def test_transform_team_total
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = home.total.to_hash
    assert hash[:team_made_field_goals] == "41", "needed 41, was #{hash[:made_field_goals]}"
    assert hash[:team_attempted_field_goals] == "90", "needed 90, was #{hash[:attempted_field_goals]}"
    assert hash[:team_attempted_free_throws] == "33", "needed 33, was #{hash[:attempted_free_throws]}"
    assert hash[:team_offensive_rebounds] == "20", "needed 20, was #{hash[:offensive_rebounds]}"
    assert hash[:team_defensive_rebounds] == "30", "needed 30, was #{hash[:defensive_rebounds]}"
    assert hash[:team_total_rebounds] == "50", "needed 50, was #{hash[:total_rebounds]}"
    assert hash[:team_turnovers] == 10, "needed 10, was #{hash[:turnovers]}"
  end

  def test_transform_away_total
    #TOTALS		FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	 	PTS
    #39-92	7-24	15-16	14	29	43	22	4	2	15	19	 	100
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = away.total.to_hash
    assert hash[:made_field_goals] == "39", "needed 39, was #{hash[:made_field_goals]}"
    assert hash[:attempted_field_goals] == "92", "needed 92, was #{hash[:attempted_field_goals]}"
    assert hash[:made_threes] == "7", "needed 7, was #{hash[:made_threes]}"
    assert hash[:attempted_threes] == "24", "needed 24, was #{hash[:attempted_threes]}"
    assert hash[:made_free_throws] == "15", "needed 15, was #{hash[:made_free_throws]}"
    assert hash[:attempted_free_throws] == "16", "needed 16, was #{hash[:attempted_free_throws]}"
    assert hash[:offensive_rebounds] == "14", "needed 14, was #{hash[:offensive_rebounds]}"
    assert hash[:defensive_rebounds] == "29", "needed 29, was #{hash[:defensive_rebounds]}"
    assert hash[:total_rebounds] == "43", "needed 43, was #{hash[:total_rebounds]}"
    assert hash[:assists] == "22", "needed 22, was #{hash[:assists]}"
    assert hash[:steals] == "4", "needed 4, was #{hash[:steals]}"
    assert hash[:blocks] == "2", "needed 2, was #{hash[:blocks]}"
    assert hash[:turnovers] == 15, "needed 15, was #{hash[:turnovers]}"
    assert hash[:personal_fouls] == "19", "needed 19, was #{hash[:personal_fouls]}"
    assert hash[:points] == "100", "needed 100, was #{hash[:points]}"
  end

  def test_transform_opponent_totals
    #TOTALS		FGM-A	3PM-A	FTM-A	OREB	DREB	REB	AST	STL	BLK	TO	PF	 	PTS
    #39-92	7-24	15-16	14	29	43	22	4	2	15	19	 	100
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = home.total.to_hash
    assert hash[:opponent_made_field_goals] == "39", "needed 39, was #{hash[:made_field_goals]}"
    assert hash[:opponent_attempted_field_goals] == "92", "needed 92, was #{hash[:attempted_field_goals]}"
    assert hash[:opponent_attempted_threes] == "24", "needed 24, was #{hash[:attempted_threes]}"
    assert hash[:opponent_attempted_free_throws] == "16", "needed 16, was #{hash[:attempted_free_throws]}"
    assert hash[:opponent_offensive_rebounds] == "14", "needed 14, was #{hash[:offensive_rebounds]}"
    assert hash[:opponent_defensive_rebounds] == "29", "needed 29, was #{hash[:defensive_rebounds]}"
    assert hash[:opponent_total_rebounds] == "43", "needed 43, was #{hash[:total_rebounds]}"
    assert hash[:opponent_turnovers] == 15, "needed 15, was #{hash[:turnovers]}"
  end

  def test_transform_home_starter
#Joakim Noah, C	34	6-10	0-0	3-6	8	8	16	4	3	3	0	3	+2	15
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = home.player_lines[2].to_hash
    assert hash[:line_name] == "Joakim Noah", "needed Joakim Noah, was #{hash[:line_name]}"
    assert hash[:position] == " C", "needed C, was #{hash[:position]}"
    assert hash[:minutes] == "34", "needed 34, was #{hash[:minutes]}"
    assert hash[:made_field_goals] == "6", "needed 6, was #{hash[:made_field_goals]}"
    assert hash[:attempted_field_goals] == "10", "needed 10, was #{hash[:attempted_field_goals]}"
    assert hash[:made_threes] == "0", "needed 0, was #{hash[:made_threes]}"
    assert hash[:attempted_threes] == "0", "needed 0, was #{hash[:attempted_threes]}"
    assert hash[:made_free_throws] == "3", "needed 3, was #{hash[:made_free_throws]}"
    assert hash[:attempted_free_throws] == "6", "needed 6, was #{hash[:attempted_free_throws]}"
    assert hash[:offensive_rebounds] == "8", "needed 8, was #{hash[:offensive_rebounds]}"
    assert hash[:defensive_rebounds] == "8", "needed 8, was #{hash[:defensive_rebounds]}"
    assert hash[:total_rebounds] == "16", "needed 16, was #{hash[:total_rebounds]}"
    assert hash[:assists] == "4", "needed 4, was #{hash[:assists]}"
    assert hash[:steals] == "3", "needed 3, was #{hash[:steals]}"
    assert hash[:blocks] == "3", "needed 3, was #{hash[:blocks]}"
    assert hash[:turnovers] == "0", "needed 0, was #{hash[:turnovers]}"
    assert hash[:personal_fouls] == "3", "needed 3, was #{hash[:personal_fouls]}"
    assert hash[:plus_minus] == "+2", "needed +2, was #{hash[:plus_minus]}"
    assert hash[:points] == "15", "needed 15, was #{hash[:points]}"

    assert hash[:games_started] == 1, "needed 1, was #{hash[:games_started]}"
  end

  def test_transform_away_reserve
#Stephen Jackson, SF	35	4-14	1-6	1-1	0	4	4	5	0	0	2	3	+6	10
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = away.player_lines[5].to_hash
    assert hash[:line_name] == "Stephen Jackson", "needed Steven Jackson, was #{hash[:line_name]}"
    assert hash[:minutes] == "35", "needed 35, was #{hash[:minutes]}"
    assert hash[:made_field_goals] == "4", "needed 4, was #{hash[:made_field_goals]}"
    assert hash[:attempted_field_goals] == "14", "needed 14, was #{hash[:attempted_field_goals]}"
    assert hash[:made_threes] == "1", "needed 1, was #{hash[:made_threes]}"
    assert hash[:attempted_threes] == "6", "needed 6, was #{hash[:attempted_threes]}"
    assert hash[:made_free_throws] == "1", "needed 1, was #{hash[:made_free_throws]}"
    assert hash[:attempted_free_throws] == "1", "needed 1, was #{hash[:attempted_free_throws]}"
    assert hash[:offensive_rebounds] == "0", "needed 0, was #{hash[:offensive_rebounds]}"
    assert hash[:defensive_rebounds] == "4", "needed 4, was #{hash[:defensive_rebounds]}"
    assert hash[:total_rebounds] == "4", "needed 4, was #{hash[:total_rebounds]}"
    assert hash[:assists] == "5", "needed 5, was #{hash[:assists]}"
    assert hash[:steals] == "0", "needed 0, was #{hash[:steals]}"
    assert hash[:blocks] == "0", "needed 0, was #{hash[:blocks]}"
    assert hash[:turnovers] == "2", "needed 2, was #{hash[:turnovers]}"
    assert hash[:personal_fouls] == "3", "needed 3, was #{hash[:personal_fouls]}"
    assert hash[:plus_minus] == "+6", "needed +6, was #{hash[:plus_minus]}"
    assert hash[:points] == "10", "needed 10, was #{hash[:points]}"
    assert hash[:games_started] == 0, "needed 0, was #{hash[:games_started]}"
  end

  def test_transform_general_info
    away, home = Scrape::TransformBoxscoreData.convert_boxscores(*@args_from_scraper)
    hash = away.player_lines[5].to_hash
    assert hash[:game_date] == "2012-01-27", "needed 2012-01-27, was #{hash[:game_date]}"
    assert hash[:team_minutes] == 240, "needed 240, was #{hash[:team_minutes]}"
    assert hash[:team] == "Milwaukee Bucks", "needed Milwaukee Bucks, was #{hash[:team]}"
    assert hash[:team_division] == "central", "needed :central, was #{hash[:team_division]}"
    assert hash[:team_conference] == "eastern", "needed eastern, was #{hash[:team_conference]}"
    assert hash[:opponent] == "Chicago Bulls", "needed Chicago Bulls, was #{hash[:opponent]}"
    assert hash[:opponent_division] == "central", "needed :central, was #{hash[:opponent_division]}"
    assert hash[:opponent_conference] == "eastern", "needed eastern, was #{hash[:opponent_conference]}"
    assert hash[:team_score] == "100", "needed 100, was #{hash[:team_score]}"
    assert hash[:opponent_score] == "107", "needed 107, was #{hash[:opponent_score]}"
    assert hash[:game_result] == "L", "needed L, was #{hash[:game_result]}"
    assert hash[:is_home] == false, "needed false, was #{hash[:is_home]}"
  end
end
