require './app/scrape/playbyplay/cbs_statistical_queries'
require './app/scrape/playbyplay/play'

module Scrape
  class CbsPlay < Play
    include Scrape::CbsStatisticalQueries

    def initialize(time, score, team, cbs_description, quarter, game_info)
      away_description = team == game_info.away_team ? cbs_description : ""
      home_description = team == game_info.home_team ? cbs_description : ""

      game_info.home_team = Nba::TEAMS.find_teamname_by_abbr(game_info.home_team) if game_info.home_team.size == 3
      game_info.away_team = Nba::TEAMS.find_teamname_by_abbr(game_info.away_team) if game_info.away_team.size == 3
      super(time, away_description, score, home_description, quarter, game_info)
    end

    def split_description
      first_description, second_description = description.split ?,
      other_team = if split_type == ASSIST
                     team
                   else
                     opponent
                   end

      first_play = Scrape::CbsPlay.new(@time, @score, team, first_description, @quarter, @game_info)
      second_play = Scrape::CbsPlay.new(@time, @score, other_team, second_description, @quarter, @game_info)
      return first_play, second_play
    end

    def player_name
      if is_attempted_field_goal?
        strip_with_index first_keyword_index
      else
        strip_index_to_end last_keyword_finish_position
      end
    end

    private
    def strip_index_to_end(index)
      description[index..-1].strip
    end

    def last_keyword_finish_position
      keyword_indexes = {}

      all_keywords.each do |keyword|
        position = matchable_description.index(keyword.downcase)
        keyword_indexes[position] = keyword
      end

      last_position = keyword_indexes.keys.compact.max
      last_position + keyword_indexes[last_position].size
    end

    def all_keywords
      ALL_KEYWORDS
    end
  end
end
