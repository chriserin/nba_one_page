#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

NbaOnePage::Application.load_tasks

namespace :scrape do
  task :playbyplay, [:game_date] => :environment do |t, arguments|
    game_date = arguments[:game_date]
    require File.expand_path('../lib/scrape/playbyplay_main', __FILE__)
    if game_date.present?
      puts "parsing #{game_date}"
      Scrape::PlaybyplayMain.scrape(DateTime.parse(game_date))
    else
      puts "parsing 2013"
      Scrape::PlaybyplayMain.scrape_2013
    end
  end

  namespace :boxscores do

    task :all_2014 => :environment do
      require './lib/scrape/boxscore_main'
      Scrape::BoxscoreMain.scrape_year("2014")
    end

    task :yesterday => :environment do
      require './lib/scrape/boxscore_main'
      Moped.logger = ActiveSupport::Logger.new("log/scrape.log")
      Scrape::BoxscoreMain.scrape
    end

    task :day, [:game_date] => :environment do |t, arguments|
      require './lib/scrape/boxscore_main'
      game_date = arguments[:game_date]
      Scrape::BoxscoreMain.scrape(DateTime.parse(game_date))
    end
  end
end

namespace :test do
  Rails::TestTask.new(units: "test:prepare") do |t|
    t.pattern = 'test/{models,helpers,unit,nba,scrape,services}/**/*_test.rb'
  end
end
