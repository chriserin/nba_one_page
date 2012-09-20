module Nba
  class Schedule
    attr_accessor :played_games, :unplayed_games

    def initialize(played_games, unplayed_games)
      self.played_games   = played_games
      self.unplayed_games = unplayed_games
    end

    def games_with_latest_as_middle(number_of_games)
      played_games_for_display(number_of_games) + unplayed_games_for_display(number_of_games)
    end

    def date_of_last_game_played
      played_games.sort_by {|game| game.game_date}.last.game_date
    end

    def latest_game_text
      played_games.last.game_text
    end

    def previous_game_text
      played_games[-1].game_text
    end

    def next_game_text
      unplayed_games.first.game_text
    end

    def all_games
      played_games + unplayed_games
    end

    def home_games
      played_games + unplayed_games
    end

    def away_games
      played_games + unplayed_games
    end

    def streak
    end

    def away_wins; end; def away_losses; end;
    def home_wins; end; def home_losses; end;
    def last_twenty_wins; end; def last_twenty_losses; end;
    def last_ten_wins; end; def last_ten_losses; end;
    def wins; end; def losses; end;

    private

    def unplayed_games_for_display(number_of_games)
      games_to_show = half_games_number_plus_remainder(number_of_games)

      if games_to_show > unplayed_games.length
        unplayed_games
      elsif games_to_show > played_games.length
        unplayed_games.first(number_of_games - played_games.length)
      else
        unplayed_games.first games_to_show
      end
    end

    def played_games_for_display(number_of_games)
      games_to_show = half_games_number(number_of_games)

      if games_to_show > unplayed_games.length
        played_games.last(number_of_games - unplayed_games.length)
      elsif games_to_show > played_games.length
        played_games
      else
        played_games.last games_to_show
      end
    end

    def number_of_played_games(number_of_games)
      number_of_games  / 2
    end

    def half_games_number_plus_remainder(number_of_games)
      half_games_number(number_of_games) + number_of_games  % 2
    end

    def half_games_number(number_of_games)
      number_of_games / 2
    end
  end
end
