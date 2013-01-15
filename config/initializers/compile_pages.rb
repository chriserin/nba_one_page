if Rails.env.production?
  Rails.application.config.after_initialize do
    require './workers/schedule_worker'
    ScheduleWorker.schedule_rebuild_cache
  end
end
