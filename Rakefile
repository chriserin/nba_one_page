#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

NbaOnePage::Application.load_tasks

namespace :scrape do
  namespace :boxscores do
    require './app/scrape/boxscore_main'

    task :all_2014 => :environment do
      Scrape::BoxscoreMain.scrape_year("2014")
    end

    task :yesterday => :environment do
      Scrape::BoxscoreMain.scrape
    end
  end
end
