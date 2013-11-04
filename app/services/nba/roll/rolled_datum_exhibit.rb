module Nba
  module Roll
    class RolledDatumExhibit < SimpleDelegator
      include ActionView::Helpers::NumberHelper

      def html_description
        line.to_html +
        html_game_data_description
      end

      def html_game_data_description
        percentage = game_data.round if game_data.present?
        percentage = number_to_percentage(game_data * 100, :precision => 0) if game_data.present? and game_data < 1.0
        "<span class='game-data'>#{percentage}</span>"
      end
    end
  end
end
