
namespace :nba_one_page do
  desc "Rebuild the page cache by submitting requests for each page"
  task :delete_canceled_games => :environment do
    ScheduledGame.where("away_team" => "Chicago Bulls", "game_date" => "2012-12-26").delete
    ScheduledGame.where("away_team" => "New York Knicks", "game_date" => "2012-11-01").delete
  end
end
