if Rails.env.production?
  Rails.application.config.after_initialize do
    p "command line #{$0}"
    if $0 =~ /unicorn/
      require './workers/schedule_worker'
      ScheduleWorker.schedule_rebuild_cache
    end
  end
end
