

class ScheduleWorker

  def self.schedule

    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_boxscores.worker')
    client.codes.create(code)
    schedule = client.schedules.create('ScrapeBoxscores', {:env => :production, :mongohq_url => ENV["MONGOHQ_URL"] || "mongodb://localhost:27017/main"}, {:start_at => Time.utc(Time.now.year, Time.now.month, Time.now.day + 1, 7), :run_every => 60*60*24 })
  end

  def self.run
    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_boxscores.worker')
    code.run
  end
end
