
namespace :nba_one_page do
  desc "Rebuild the page cache by submitting requests for each page"
  task :rebuild => :environment do
    require './workers/schedule_worker'
    ScheduleWorker.schedule_rebuild_cache
  end
end
