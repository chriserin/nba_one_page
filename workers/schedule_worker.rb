class ScheduleWorker

  def self.schedule_scraper

    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_boxscores.worker')
    client.codes.create(code)
    worker_options = {
      :env => :production,
      :mongohq_url => ENV["MONGOHQ_URL"] || "mongodb://localhost:27017/main"
    }
    schedule_options = {
      :start_at => Time.utc(Time.now.year, Time.now.month, Time.now.day + 1, 7),
      :run_every => 60*60*24 
    }
    schedule = client.schedules.create('ScrapeBoxscores', worker_options, schedule_options)
  end

  def self.schedule_playbyplay_scraper
    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_playbyplay.worker')
    client.codes.create(code)
    worker_options = {
      :env => :production,
      :mongohq_url => ENV["MONGOHQ_URL"] || "mongodb://localhost:27017/main"
    }
    schedule_options = {
      :start_at => Time.utc(Time.now.year, Time.now.month, Time.now.day + 1, 7),
      :run_every => 60*60*24 
    }
    schedule = client.schedules.create('ScrapePlaybyplay', worker_options, schedule_options)
  end

  def self.schedule_keep_alive

    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/keep_alive.worker')
    client.codes.create(code)
    schedule = client.schedules.create('KeepAlive', { :env => :production }, { :start_at => Time.now, :run_every => 60*60 })
  end

  def self.schedule_rebuild_cache

    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/rebuild_cache.worker')
    client.codes.create(code)
    schedule = client.schedules.create('RebuildCache', { :env => :production }, { :start_at => Time.now + 30 })
  end

  def self.schedule_all
    schedule_scraper
    schedule_keep_alive
  end

  def self.run_scraper
    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_boxscores.worker')
    code.run
  end

  def self.run_playbyplay_scraper
    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_playbyplay.worker')
    code.run
  end

  def self.run_keep_alive
    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/keep_alive.worker')
    code.run
  end

  def self.run_rebuild_cache
    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/rebuild_cache.worker')
    code.run
  end
end
