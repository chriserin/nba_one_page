module Nba
  class GameDescriptor
    def initialize(game)
      @game = game
    end

    def game_text
      delimiter = ( @game.is_home ? "" : "@" )
      if @game.is_home?
        "#{delimiter}#{@game.opponent_abbr} #{@game.opponent_score}-#{@game.team_score}"
      else
        "#{delimiter}#{@game.opponent_abbr} #{@game.team_score}-#{@game.opponent_score}"
      end
    end

    def result_description
      "#{@game.game_result}#{difference_indicator}#{@game.plus_minus.abs}"
    end

    def formatted_game_date
      game_date.to_date.strftime("%m/%d")
    end

    def to_s
      "#{formatted_game_date} #{game_text}"
    end

    def to_html
      <<-HEREDOC
            <span class="game-date">#{ formatted_game_date }</span>
            <span class="#{@game.game_result}">#{@game.game_result}</span>
            <span class="game-description">#{ game_text }</span>
      HEREDOC
    end

    private
    def game_date
      @game.game_date
    end

    def difference_indicator
      @game.game_result == "W" ? "+" : "-"
    end
  end
end
