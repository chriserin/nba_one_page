module Nba
  class Schedule
    attr_accessor :played_games, :unplayed_games, :team

    def initialize(played_games, unplayed_games, team)
      self.played_games   = played_games
      self.unplayed_games = unplayed_games
      self.team = Nba::TEAMS.keys.find { |key| key =~ /#{team}/}
    end

    def games_with_latest_as_middle(number_of_games)
      (played_games_for_display(number_of_games) + unplayed_games_for_display(number_of_games)).reverse
    end

    def date_of_last_game_played
      if played_games.size > 0
        played_games.sort_by {|game| game.game_date}.last.game_date
      else
        nil
      end
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
      (played_home_games + unplayed_home_games).reverse
    end

    def filtered_unplayed_games
      unplayed_games.select {|game| game.game_date > DateTime.parse(played_games.last.game_date) }
    end

    def unplayed_home_games
      filtered_unplayed_games.select {|game| game.home_team == team }
    end
    alias upcoming_home_games unplayed_home_games

    def unplayed_away_games
      filtered_unplayed_games.select {|game| game.away_team == team }
    end
    alias upcoming_away_games unplayed_away_games

    def played_home_games
      played_games.select {|game| game.is_home }
    end

    def played_away_games
      played_games.select {|game| not game.is_home }
    end

    def away_games
      (played_away_games + unplayed_away_games).reverse
    end

    def streak
    end

    def away_wins; end; def away_losses; end;
    def home_wins; end; def home_losses; end;
    def last_twenty_wins; end; def last_twenty_losses; end;
    def last_ten_wins; end; def last_ten_losses; end;
    def wins; end; def losses; end;

    private

    def unplayed_games_for_display(n)
      games_to_show = n / 2 + n % 2

      if games_to_show > unplayed_games.length
        unplayed_games
      elsif games_to_show > played_games.length
        unplayed_games.first(n - played_games.length)
      else
        unplayed_games.first games_to_show
      end
    end

    def played_games_for_display(n)
      games_to_show = n / 2

      if games_to_show > unplayed_games.length
        played_games.last(n - unplayed_games.length)
      elsif games_to_show > played_games.length
        played_games
      else
        played_games.last games_to_show
      end
    end
  end
end
