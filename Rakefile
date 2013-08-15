#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

NbaOnePage::Application.load_tasks

namespace :test do
  Rails::TestTask.new(units: "test:prepare") do |t|
    t.pattern = 'test/{models,helpers,unit,nba,scrape,services}/**/*_test.rb'
  end
end

namespace :request do
  task :get, [:path] => :environment do |t, args|
    session = ActionDispatch::Integration::Session.new(Rails.application)
    response_code = session.get URI.encode(args.first.second)
    case response_code
    when 200 then STDOUT.puts session.body
    when 404 then STDOUT.print session.response.body
    when 500 then STDOUT.print session.response.body
    else
      STDOUT.puts session.response.body
    end
    STDOUT.puts response_code
  end
end

namespace :scrape do
  task :playbyplay, [:team, :game_date] => :environment do |t, arguments|
    game_date = arguments[:game_date]
    require File.expand_path('../app/scrape/playbyplay_main', __FILE__)
    if game_date.present?
      STDOUT.print "parsing #{game_date}"
      Scrape::PlaybyplayMain.scrape(DateTime.parse(game_date))
    else
      STDOUT.print "parsing 2013"
      Scrape::PlaybyplayMain.scrape_2013
    end
  end
end
