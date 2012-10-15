
require 'mongoid'
require 'mechanize'
require 'teams'
require 'game_line'
require 'scraper_steps/scraper_step'
require 'scraper_steps/scrape_boxscores'
require 'scraper_steps/nba_scoreboard_scraper'
require 'scraper_steps/nba_boxscore_scraper'
require 'scraper_steps/nba_boxscore_converter'

Mongoid.load!('mongoid.yml', params[:env])

scoreboard_date = if params[:env] == :development
                    DateTime.new 2012, 3, 15
                  elsif params[:env] == :production
                    nil
                  end

ScrapeBoxscores.scrape(scoreboard_date)
