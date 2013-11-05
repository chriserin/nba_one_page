require './lib/mechanize/page'
require './lib/scrape/scraper_tools'

module Scrape
  module Playbyplay
    module Scraper
      extend ScraperTools

      PLAYBYPLAY_TABLES = "table.shsTable.shsBorderTable"

      def self.scrape(url)
        agent = Mechanize.new

        game_rows = []

        agent.get(url) do |page|
          tables = page.search(PLAYBYPLAY_TABLES)

          each_table(tables) do |table|
            each_row(table) do |row|
              play = []
              game_rows << play

              each_column(row) do |data|
                play << data.text
              end
            end
          end
        end

        return game_rows
      end
    end
  end
end
