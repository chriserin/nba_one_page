require './lib/scrape/lineups/lineup'
require './app/services/nba/base_statistics'

module Scrape
  class OnCourtStretch
    attr_accessor :start, :end, :lineups
    def initialize(lineups=nil, options = {})
      options = {:start => nil, :end => nil}.merge(options)
      @lineups = lineups || Hash.new
      empty_lineup = @lineups.delete(nil) if @lineups.keys.include? nil
      @lineups.default_proc = proc { |hash, team| hash[team] = empty_lineup || Scrape::Lineup.new([])}
      @stats = Hash.new {|hash, team| hash[team] = Hash.new(0)}
      @start = options[:start]
      @end = options[:end]
    end

    def has_lineups?
      @lineups.size == 2
    end

    def process_play(play)
      set_time(play)
      increment_stats(play)
      return determine_lineup(play)
    end

    def set_time(play)
      @start = play.seconds_passed if @start.blank?
      @end   = play.seconds_passed if @end.blank?
      @start = play.seconds_passed if play.seconds_passed < @start
      @end   = play.seconds_passed if play.seconds_passed > @end
    end

    def increment_stats(play)
      Nba::TalleableStatistics.each do |stat_name|
        @stats[play.team][stat_name] += 1 if play.send("is_#{stat_name.to_s.singularize}?")
      end
    end

    def determine_lineup(play)
      if play.is_exit?
        other_team = (@lineups.keys - [play.team]).pop
        lineups = {
          play.team => @lineups[play.team].player_exit(play.player_name),
          other_team => @lineups[other_team].duplicate_lineup
        }
        return OnCourtStretch.new lineups
      elsif play.is_entrance?
        @lineups[play.team].add_substituted_player(play.player_name)
        play.lineup = @lineups[play.team]
        return self
      elsif play.is_quarter_start?
        return OnCourtStretch.new nil, start: play.seconds_passed
      elsif play.is_quarter_end?
        return OnCourtStretch.new
      else
        @lineups[play.team].add_player(play.player_name)
        play.lineup = @lineups[play.team]
        return self
      end
    end

    def verify_full_lineups
      raise Scrape::TooManyTeamsError.new("too many teams") if @lineups.keys.count > 2
      @lineups.each do |team, lineup|
        raise Scrape::LineupNotFullError.new("#@start #@end lineup #{team.to_s} #{lineup} not full") unless lineup.is_full? or (@start == @end)
      end
    end

    def to_hash(index, game_date)
      { team: @lineups.keys[index],
        opponent: @lineups.keys[other_index(index)],
        game_date: game_date,
        team_players: @lineups.values[index].to_a,
        opponent_players: @lineups.values[other_index(index)].to_a,
        start: @start,
        end: @end
      }.merge(@stats[@lineups.keys[index]]) if @stats[@lineups.keys[index]]
    end

    def other_index(index)
      if index == 1
        return 0
      else
        return 1
      end
    end
  end
end
