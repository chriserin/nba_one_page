require './lib/scrape/playbyplay/scraper'
require './lib/scrape/playbyplay/assembly_line'

module Scrape
  module Playbyplay
    def self.get_season(season)
      PlayModel(season).delete_all

      Nba::Calendar.season_range(season).each do |date|
        get_plays(date)
        sleep(1)
      end
    end

    def self.get_range(start, range_end=DateTime.now - 1)
      (start..range_end).each do |date|
        get_plays(date)
      end
    end

    def self.get_plays(game_date=DateTime.now - 1)
      puts "GAME DATE #{game_date}"
      PlayModel(game_date).where("game_date" => game_date).delete
      urls = get_urls(game_date)

      urls.each do |url, game_info|
        table_rows = Scrape::Playbyplay::Scraper.scrape(url)

        assemble_plays(table_rows, game_info)
      end
    end

    AL = Scrape::Playbyplay::AssemblyLine
    def self.assemble_plays(table_rows, game_info, verify = true)
      play_objects   = AL.rows_to_plays(table_rows, game_info)
      play_models    = AL.save_plays(play_objects, game_info.game_date)
      AL.verify_plays(play_models) if verify

      stretches      = AL.determine_stretches(play_objects)
      stretch_models = AL.save_stretches(stretches, game_info.game_date)
      AL.verify_stretches(stretch_models) if verify
    end

    def self.get_urls(game_date)
      scoreboard_scraper = ScoreboardScraper.new
      scoreboard_scraper.nbc_playbyplay_urls(game_date) #returns [[url, game_info]]
    end
  end
end
