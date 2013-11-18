
require 'mongoid'
require 'mechanize'
require 'teams'
require 'stat_formulas'
require 'base_statistics'
require 'calendar'

require 'class_accessors'
require 'display_attributes'
require 'game_line_descriptor'
require 'year_types'
require 'game_line'
require 'difference'
require 'difference_line'

require 'scrape/clear_cache'
require 'scrape/boxscore_main'
require 'page'

params['env'] ||= "development"
Mongoid.load!('mongoid.yml', params['env'])

scoreboard_date = if params['env'] == "development"
                    DateTime.new 2012, 3, 15
                  elsif params['env'] == "production"
                    DateTime.now - 1
                  end

Scrape::BoxscoreMain.scrape(scoreboard_date)
