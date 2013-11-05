module Scrape
  module Lineups
    module SortPlays
      def sort_plays(plays)
        grouped = plays.group_by {|play| play.seconds_passed}
        grouped.each do |k, ps|
          GroupedPlays.new(ps)
        end
        grouped.values.flatten
      end
    end

    class GroupedPlays
      def initialize(plays)
        @plays = plays#purpose of class is to mutate this variable
        return if too_complex?
        if @plays.find {|p| p.is_exit?}
          reorder_exit_plays
        end
        if @plays.find {|p| p.is_entrance?}
          reorder_entrance_plays
        end
      end

      def too_complex?
        player_names = @plays.map {|p| p.player_name}.uniq
        player_names.each do |name|
          if players_plays(name).find {|p| p.is_exit? } and
            players_plays(name).find {|p| p.is_entrance? }
            return true
          end
        end
        return false
      end

      def players_plays(name)
        @plays.select {|p| p.player_name == name}
      end

      def reorder_exit_plays
        exit_plays.each do |exit_play|
          move_out_of_order_plays(exit_play)
        end
      end

      def reorder_entrance_plays
        entrance_plays.each do |entrance_play|
          move_out_of_order_entrance_play(entrance_play)
        end
      end

      def exit_plays
        @plays.select {|p| p.is_exit?}
      end

      def entrance_plays
        @plays.select {|p| p && p.is_entrance?}
      end

      def first_exit_play_index
        @plays.index(exit_plays.first)
      end

      def last_entrance_play_index
        @plays.index(entrance_plays.last)
      end

      def move_out_of_order_entrance_play(entrance_play)
        entrance_player = entrance_play.player_name
        entrance_index = @plays.index(entrance_play)
        enum = @plays.enum_for(:each_with_index)
        ooo_plays = enum.select do |play, index|
          play && !play.is_entrance? and
            play.player_name == entrance_player and
            index < entrance_index
        end
        Hash[ooo_plays].keys.each &method(:move).to_proc.curry[last_entrance_play_index + 1]
      end

      def move_out_of_order_plays(exit_play)
        exit_player = exit_play.player_name
        exit_index = @plays.index(exit_play)
        enum = @plays.enum_for(:each_with_index)
        ooo_plays = enum.select do |play, index|
          !play.is_exit? and
            play.player_name == exit_player and
            index > exit_index
        end
        Hash[ooo_plays].keys.each &method(:move).to_proc.curry[first_exit_play_index]
      end

      def move(to, play)
        @plays.insert(to, @plays.delete(play))
      end
    end
  end
end
