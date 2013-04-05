
namespace :nba_one_page do
  desc "delete all the cancelled games for the year."
  task :delete_cancelled_games => :environment do
    ScheduledGame.where("away_team" => "Chicago Bulls", "game_date" => "2012-12-26").delete
    ScheduledGame.where("away_team" => "New York Knicks", "game_date" => "2012-11-01").delete
  end

  task :add_rescheduled_games => :environment do
    ScheduledGame.create!(:game_date => "2013-02-04", :away_team => "Chicago Bulls", :home_team => "Indiana Pacers")
    ScheduledGame.create!(:game_date => "2012-11-26", :away_team => "New York Knicks", :home_team => "Brooklyn Nets")
  end
end
