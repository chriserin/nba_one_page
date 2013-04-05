
require 'mongoid'
require 'mechanize'
require 'teams'
require 'stat_formulas'
require 'base_statistics'

require 'difference'
require 'difference_model'
require 'game_model'
require 'line_type_factory'

require 'scraper_steps/scraper_step'
require 'scraper_steps/clear_cache'
require 'scraper_steps/scrape_boxscores'
require 'scraper_steps/nba_scoreboard_scraper'
require 'scraper_steps/nba_boxscore_scraper'
require 'scraper_steps/nba_boxscore_converter'

params['env'] ||= "development"
Mongoid.load!('mongoid.yml', params['env'])

scoreboard_date = if params['env'] == "development"
                    DateTime.new 2012, 3, 15
                  elsif params['env'] == "production"
                    DateTime.now - 1
                  end

ScrapeBoxscores.scrape(scoreboard_date)
