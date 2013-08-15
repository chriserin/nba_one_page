require 'logger'
require 'fileutils'

class InfoLogger
  INFO_LOGGERS_PATH = "log/info_loggers"
  def self.method_missing(meth, *args, &block)
    @loggers ||= {}
    FileUtils.mkdir_p(INFO_LOGGERS_PATH)
    FileUtils.rm_f(INFO_LOGGERS_PATH + "/#{meth}.txt") unless @loggers[meth]
    @loggers[meth] ||= Logger.new(INFO_LOGGERS_PATH + "/#{meth}.txt")
    @loggers[meth].info(args.first.to_s)
  end
end
