require 'iron_worker'

class BoxscoreScraperWorker < IronWorker::Base

  attr_accessor :mongo_url

  def run
    puts "boxscore worker"

  end
end
