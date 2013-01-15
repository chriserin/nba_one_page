require './workers/schedule_worker'

if Rails.env.production?
  Rails.application.config.after_initialize do
    ScheduleWorker.schedule_rebuild_cache
  end
end
