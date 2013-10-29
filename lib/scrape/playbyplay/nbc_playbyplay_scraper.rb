require './lib/mechanize/page'
require './lib/scrape/scraper_tools'

class NbcPlaybyplayScraper
  include ScraperTools

  PLAYBYPLAY_TABLES = "table.shsTable.shsBorderTable"

  def initialize(next_step)
    @next_step = next_step
  end

  def run(playbyplay_urls)
    playbyplay_urls.each do |url|
      results = scrape(*url)
      @next_step.run(*results)
    end
  end

  def scrape(*args)
    url = args.shift
    agent = Mechanize.new

    game_rows = []
    home_team = args[0]
    away_team = args[1]
    game_date = args[2]

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

    return game_rows, home_team, away_team, game_date, :nbc
  end
end
