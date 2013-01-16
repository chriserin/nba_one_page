if Rails.env.production?
  Rails.application.config.after_initialize do
    p "args after initialize #{ARGV}"
    if ARGV.blank?
      require './workers/schedule_worker'
      ScheduleWorker.schedule_rebuild_cache
    end
  end
end
