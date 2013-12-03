module Nba
  module Roll
    class RolledDatumExhibit < SimpleDelegator
      include ActionView::Helpers::NumberHelper

      def html_description
        line.to_html +
        html_game_data_description
      end

      private
      def html_game_data_description
        "<span class='game-data'>#{format_data}</span>"
      end

      def format_data
        if formula.nil?
          "-"
        elsif formula == :rolling_average
          game_data
        elsif formula.to_sym == :game_score
          game_data
        elsif formula.to_s[-3..-1] == "_36"
          game_data
        else
          percentage = game_data.round if game_data.present?
          percentage = number_to_percentage(game_data * 100, :precision => 0) if game_data.present?
        end
      end
    end
  end
end
