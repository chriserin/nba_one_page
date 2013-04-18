class Scrape::GameInfo < Struct.new(:home_team,
                                    :away_team,
                                    :game_date,
                                    :home_score,
                                    :away_score,
                                    :periods,
                                    :home_turnovers,
                                    :away_turnovers)
end
