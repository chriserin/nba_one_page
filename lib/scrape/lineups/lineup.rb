
module Scrape
  class Lineup
    attr_accessor :piggy_back_lineup

    def initialize(init_array)
      @lineup_array = init_array.dup
      @blacklist = []
    end

    def to_s
      @lineup_array.to_s
    end

    def add_player(player)
      @lineup_array << player unless is_blacklisted?(player)
      @lineup_array.uniq!
      update_piggy_backed_lineup(player)
      raise Scrape::Error.new "lineup has too many players #@lineup_array" if @lineup_array.size > 5
    end

    def add_substituted_player(player)
      blacklist_player_for_piggy_backed_lineup(player)
      add_player(player)
    end

    def player_exit(player_out)
      add_player(player_out) #if exiting player isn't already included, then add player
      new_lineup = Scrape::Lineup.new(@lineup_array - [player_out])
      new_lineup.piggy_back_lineup = self unless is_full?
      return new_lineup
    end

    def duplicate_lineup
      new_lineup = Scrape::Lineup.new(@lineup_array)
      new_lineup.piggy_back_lineup = self unless is_full?
      return new_lineup
    end

    def update_piggy_backed_lineup(player)
      @piggy_back_lineup && @piggy_back_lineup.add_player(player)
    end

    def blacklist_player_for_piggy_backed_lineup(player)
      @piggy_back_lineup && @piggy_back_lineup.blacklist_player(player)
    end

    def blacklist_player(player)
      @blacklist << player
      blacklist_player_for_piggy_backed_lineup(player)
    end

    def is_blacklisted?(player)
      @blacklist.include? player
    end

    def is_full?
      @lineup_array.size == 5
    end

    def to_a
      @lineup_array
    end
  end
end
