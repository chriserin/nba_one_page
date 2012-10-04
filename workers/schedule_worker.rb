

class ScheduleWorker

  def self.schedule

    client = IronWorkerNG::Client.new
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/scrape_boxscores.worker')
    client.codes.create(code)
    schedule = client.schedules.create('ScrapeBoxscores', {:env => :production, :mongohq_url => ENV["MONGOHQ_URL"] || "mongodb://localhost:27017/main"}, {:start_at => Time.utc(2012, 10, 6, 7), :every => 60*60*24 })
  end
end
