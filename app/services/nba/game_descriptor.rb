module Nba
  module GameDescriptor

    def shortened_game_text
      delimiter = ( is_home ? "" : "@" )
      if is_home?
        "#{delimiter}#{opponent_abbr} #{opponent_score}-#{team_score}"
      else
        "#{delimiter}#{opponent_abbr} #{team_score}-#{opponent_score}"
      end
    end

    def game_text
      method = __getobj__.method(:game_text)
      if method
        method.call
      else
        shortened_game_text
      end
    end

    def result_description
      "#{game_result}#{difference_indicator}#{plus_minus.abs}"
    end

    def game_description
      if played?
        game_text
      else
        game_text_for team
      end
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
            <span class="#{game_result}">#{game_result}</span>
            <span class="game-description">#{ game_text }</span>
      HEREDOC
    end

    private
    def difference_indicator
      game_result == "W" ? "+" : "-"
    end
  end
end
