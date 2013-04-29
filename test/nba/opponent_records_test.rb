require './test/test_helper'

class OpponentRecordsTest < MiniTest::Unit::TestCase
  def test_opponent_win_pct

    sample = OpponentRecordsSample.new
    assert sample.opponent_win_pct == 0.5, "opponent_win_pct should be .5 but is #{sample.opponent_win_pct}"
  end

  class OpponentRecordsSample
    include Nba::OpponentRecords

    def opponent_records
      record_a = ActiveSupport::OrderedOptions.new
      record_a.wins = 10
      record_a.losses = 0
      record_b = ActiveSupport::OrderedOptions.new
      record_b.wins = 0
      record_b.losses = 10
      [record_a, record_b]
    end
  end
end
