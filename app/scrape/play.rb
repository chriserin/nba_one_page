module Scrape; end
require './app/scrape/statistical_queries'

class Scrape::Play
  include Scrape::StatisticalQueries

  def initialize(time, away_description, score, home_description, quarter, split=false, original_description="")
    @time             = time
    @away_description = away_description.strip
    @home_description = home_description.strip
    @quarter          = quarter
    @score            = score
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

  def split_description
    if split_type == BLOCK
      description.match(/(.*#{BLOCKS})(.*)/)
      first_group, second_group = $1, $2
    elsif split_type == ENTERS_THE_GAME_FOR
      description.match(/(.*#{ENTERS_THE_GAME_FOR})(.*)/)
      first_group, second_group = $1, $2 + EXITS_THE_GAME
    else
      description.match(/(.*)\((.*)\)/)
      first_group, second_group = $1, $2
    end

    if @home_description.present?
      first_away_desc, first_home_desc, second_away_desc, second_home_desc = determine_split_home_descriptions(first_group, second_group)
    else
      first_away_desc, first_home_desc, second_away_desc, second_home_desc = determine_split_away_descriptions(first_group, second_group)
    end

    first_play  = Scrape::Play.new(@time, first_away_desc, @score, first_home_desc, @quarter, true, description)
    second_play = Scrape::Play.new(@time, second_away_desc, @score, second_home_desc, @quarter, true, description)
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

  def player_name
    description[0...first_keyword_index].strip.split(?').first
  end

  def first_keyword_index
    keyword_indexes = []

    ALL_KEYWORDS.each do |keyword|
      keyword_indexes << description.index(keyword)
    end

    keyword_indexes.compact.min
  end
end
