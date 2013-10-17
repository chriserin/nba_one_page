require 'delegate'

class DateHash < Hash
  def from(a, b)
    self.select {|k, v| k.to_date >= a.to_date && k.to_date <= b.to_date}
  end
end

module Nba
  class GameRegister
    attr_reader :register

    def initialize(scheduleds, games)
      @register = reduce_to_hash(scheduleds, :away_team)
      @register = @register.deep_merge(reduce_to_hash(scheduleds, :home_team))
      @register = @register.reduce({}) do |h, (team, dated_games)|
        h[team] = DateHash[dated_games.sort]
        h[team].default_proc = proc { RestDay }
        h
      end

      defaulted_hash = Hash.new { RestDay }
      set_played_games(games)
    end

    def group(team)
      @register[team]
    end

    def specific(team, date)
      @register[team][date.to_date]
    end

    private

    def set_played_games(games)
      games.each do |game|
        game_delegate = @register[game.team][game.game_date.to_date]
        if Nba::RestDay == game_delegate
          @register[game.team][game.game_date.to_date] = Game.new(game)
        else
          game_delegate.set(game)
        end
      end
    end

    def reduce_to_hash(scheduleds, method)
      grouped = scheduleds.group_by {|schd| schd.send(method)}
      Hash[grouped.map do |team, sds|
        [team, sds.reduce({}) {|h, schd| h[schd.game_date] = Game.new(schd); h}]
      end]
    end
  end

  class Game < SimpleDelegator
    def set(line)
      __setobj__(line)
    end

    def played?
       GameModel === __getobj__
    end
  end

  class RestDay
  end
end
