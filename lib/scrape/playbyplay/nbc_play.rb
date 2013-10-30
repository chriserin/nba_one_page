require './lib/scrape/playbyplay/nbc_statistical_queries'
require './lib/scrape/playbyplay/game_time'
require './lib/scrape/playbyplay/nbc_description_splitting'

module Scrape
  class NbcPlay
    include Scrape::NbcStatisticalQueries
    include Scrape::NbcDescriptionSplitting

    attr_reader :original_description
    attr_reader :game_info
    attr_accessor :lineup

    def initialize(quarter, time, team, nbc_description, away_score, home_score, game_info, original_description="")
      @quarter = quarter
      @time = time
      @team = team
      @description = nbc_description
      @away_score = away_score
      @home_score = home_score
      @game_info = game_info
      @original_description = original_description
    end

    def to_s
      if @original_description.present?
        desc = @original_description
      else
        desc = @description
      end
      "#{@team} #{@time} #{desc}"
    end

    def team_score
      0
    end

    def opponent_score
      0
    end

    def score_difference
      0
    end

    def team
      Nba::TEAMS.find_teamname_by_alt_abbr(@team) || @team
    end

    def opponent
      @game_info.other_team(team)
    end

    def game_date
      @game_info.game_date.strftime("%Y-%m-%d")
    end

    def description
      @description
    end

    def matchable_description
      @description.downcase
    end

    def seconds_passed
      game_time = Scrape::GameTime.new(@quarter, @time)
      game_time.total_seconds
    end

    NAME_DELIMS = %w{
      with\ a
      with\ the
      is\ charged
      makes
      misses
      blocks
      steals
      exits
      enters
      turnover
      ejected
    } + SHOT_MODIFIERS + SHOT_TYPES

    def player_name
      if is_foul? and not is_ejection?
        keyword = "committed by"
        index = description.index keyword
        last_position = index + keyword.size
        description[last_position..-1].strip.gsub(?., "")
      else
        description[0...delim_index].strip.gsub(?., "")
      end
    end

    def delim_index
      indexes = NAME_DELIMS.map do |delim|
        matchable_description.index delim
      end
      indexes.compact.min || -1
    end

    def split_description
      first_desc, second_desc = split_description_by_type(description)
      first_team, second_team = split_team_by_type(description, team, @game_info)

      first_play = NbcPlay.new(@quarter, @time, first_team, first_desc, @away_score, @home_score, @game_info, description)
      second_play = NbcPlay.new(@quarter, @time, second_team, second_desc, @away_score, @home_score, @game_info, description)
      return first_play, second_play
    end
  end
end
