class Scrape::ConvertedBoxscore < Struct.new(:total,
                                             :opponent_total,
                                             :player_lines,
                                             :bench_total,
                                             :starters_total)
end
