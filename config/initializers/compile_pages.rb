if Rails.env.production?
  Rails.application.config.after_initialize do
    if $0 =~ /unicorn/
      ##require './workers/schedule_worker'
      ##ScheduleWorker.schedule_rebuild_cache
    end
  end
end
