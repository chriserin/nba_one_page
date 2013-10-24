module Nba
  module Difficulty
    def difficulty(game)
      result  = 6 * pct
      result += 4 * Nba::Team.get(game.opponent).pct
      result += game.is_home? ? 0 : 1
      result += rest_rating(game)
      result -= Nba::Team.get(game.opponent).rest_rating(game)
      result.round(1)
    end

    def rest_rating(game)
      rating = 0
      rating += 1 if is_back_to_back?(game.game_date)
      rating += 1 if is_four_in_five?(game.game_date)
      return rating
    end
  end
end
