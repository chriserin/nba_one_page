class Scrape::ConvertedBoxscore < Struct.new(:total,
                                             :opponent_total,
                                             :difference_total,
                                             :player_lines)
end
