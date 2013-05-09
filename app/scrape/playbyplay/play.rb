require './app/scrape/playbyplay/statistical_queries'

module Scrape
  class Play
    include Scrape::StatisticalQueries

    attr_reader :original_description

    def initialize(time, away_description, score, home_description, quarter, game_info, split=false, original_description=nil)
      @time                 = time
      @quarter              = quarter
      @score                = score
      @game_info            = game_info
      @away_description     = away_description.strip
      @home_description     = home_description.strip
      @original_description = original_description || description
    end

    def duplicate_with_new_description(new_description)
      x = 1, away_description = new_description, home_description = "" if @away_description.present?
      x = 1, home_description = new_description, away_description = "" if @home_description.present?
      Scrape::Play.new(@time, away_description, @score, home_description, @quarter, @game_info)
    end

    def seconds_passed
      minutes, seconds = @time.split ?:
      minutes_elapsed  = 12 - (minutes.to_i + 1)
      seconds_elapsed  = 60 - seconds.to_i
      quarter_seconds  = (@quarter - 1) * 12 * 60
      return minutes_elapsed * 60 + seconds_elapsed + quarter_seconds
    end

    def description
      return @home_description if @away_description.blank?
      @away_description
    end

    def away_score
      away, home = @score.split ?-
      return away.to_i
    end

    def home_score
      away, home = @score.split ?-
      return home.to_i
    end

    def team_score
      return home_score if is_home_play?
      away_score
    end

    def opponent_score
      return away_score if is_home_play?
      home_score
    end

    def game_date
      @game_info.game_date
    end

    def is_home_play?
      @home_description.present?
    end

    def score_difference
      return home_score - away_score if is_home_play?
      away_score - home_score
    end

    def team
      return Nba::TEAMS.find(@game_info.home_team) if is_home_play?
      Nba::TEAMS.find(@game_info.away_team)
    end

    def opponent
      return Nba::TEAMS.find(@game_info.away_team) if is_home_play?
      Nba::TEAMS.find(@game_info.home_team)
    end

    def keyword_count
      ALL_KEYWORDS.count {|keyword| description.include? keyword}
    end

    def split_description
      if split_type == BLOCK
        description.match(/(.*#{BLOCK})(.*)/)
          first_group, second_group = $1, $2 + " misses"
      elsif split_type == ENTERS_THE_GAME_FOR
        description.match(/(.*#{ENTERS_THE_GAME_FOR})(.*)/)
          first_group, second_group = $1, $2 + " " + EXITS_THE_GAME
      elsif split_type == DRAWS_THE_FOUL and keyword_count == 1
        description.match(/(.*)\((.*)\)/)
        first_group, second_group = $1.strip + " personal foul", $2
      else
        description.match(/(.*)\((.*)\)/)
        first_group, second_group = $1, $2
      end

      if @home_description.present?
        first_away_desc, first_home_desc, second_away_desc, second_home_desc = determine_split_home_descriptions(first_group, second_group)
      else
        first_away_desc, first_home_desc, second_away_desc, second_home_desc = determine_split_away_descriptions(first_group, second_group)
      end

      first_play  = Scrape::Play.new(@time, first_away_desc, @score, first_home_desc, @quarter, @game_info, true, description)
      second_play = Scrape::Play.new(@time, second_away_desc, @score, second_home_desc, @quarter, @game_info, true, description)
      return first_play, second_play
    end

    def determine_split_home_descriptions(first_group, second_group)
      if split_type == BLOCK
        first_away_desc  = first_group
        first_home_desc  = ""
        second_away_desc = ""
        second_home_desc = second_group
      elsif split_type == ASSIST or split_type == ENTERS_THE_GAME_FOR
        first_away_desc  = ""
        first_home_desc  = first_group
        second_away_desc = ""
        second_home_desc = second_group
      else
        first_away_desc  = ""
        first_home_desc  = first_group
        second_away_desc = second_group
        second_home_desc = ""
      end

      return first_away_desc, first_home_desc, second_away_desc, second_home_desc
    end

    def determine_split_away_descriptions(first_group, second_group)
      if split_type == BLOCK
        first_away_desc  = ""
        first_home_desc  = first_group
        second_away_desc = second_group
        second_home_desc = ""
      elsif split_type == ASSIST or split_type == ENTERS_THE_GAME_FOR
        first_away_desc  = first_group
        first_home_desc  = ""
        second_away_desc = second_group
        second_home_desc = ""
      else
        first_away_desc  = first_group
        first_home_desc  = ""
        second_away_desc = ""
        second_home_desc = second_group
      end

      return first_away_desc, first_home_desc, second_away_desc, second_home_desc
    end

    GAINS_POSSESSION = "gains possession"
    def player_name
      return "" if matchable_description.include? GAINS_POSSESSION
      description[0...first_keyword_index].strip.split(?').first
    end

    def first_keyword_index
      keyword_indexes = []

      ALL_KEYWORDS.each do |keyword|
        keyword_indexes << matchable_description.index(keyword.downcase)
      end

      keyword_indexes.compact.min
    end
  end
end
