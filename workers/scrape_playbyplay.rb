
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
require 'play_model'
require 'stretch_line'

require './lib/scrape/scoreboard_scraper'
require './lib/scrape/playbyplay'
require './lib/mechanize/page'

params['env'] ||= "development"
Mongoid.load!('mongoid.yml', params['env'])

scoreboard_date = DateTime.now - 1

Scrape::Playbyplay.get_plays(scoreboard_date)
