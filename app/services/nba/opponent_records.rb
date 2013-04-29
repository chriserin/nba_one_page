module Nba
  module OpponentRecords
    def collect_opponents(games)
      @opponents = games.map { |g| g.opponent }
    end

    def opponent_win_pct
      o_wins, o_losses = opponents_combined_record
      o_wins / ((o_wins + o_losses) * 1.0)
    end

    def opponents_combined_record
      return @opponent_wins, @opponent_losses if @opponent_wins
      records = opponent_records
      @opponent_wins, @opponent_losses = opponent_wins(records), opponent_losses(records)
    end

    def opponent_wins(records)
      records.map { |record| record.wins }.inject(:+)
    end

    def opponent_losses(records)
      records.map { |record| record.losses }.inject(:+)
    end

    def opponent_records
      raise "abstract method"
    end
  end
end
