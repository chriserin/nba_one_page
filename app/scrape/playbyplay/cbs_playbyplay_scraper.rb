require './lib/mechanize/page'

class CbsPlaybyplayScraper
  include ScraperTools

  PLAYBYPLAY_ROWS = "table.condensed tr"

  def initialize(next_step)
    @next_step = next_step
  end

  def run(playbyplay_urls)
    playbyplay_urls.each do |url|
      results = scrape(url)
      @next_step.run(*results)
    end
  end

  def scrape(url)
    agent = Mechanize.new

    game_rows = []
    away_team, home_team, game_date = "", "", ""
    url.match(/NBA_(\d{8})_(\w{3})@(\w{3})/)
    game_date = DateTime.parse($1)
    away_team = $2
    home_team = $3

    agent.get(url) do |page|
      table = page.search(PLAYBYPLAY_ROWS)

      each_row(table) do |row|
        play = []
        game_rows << play

        each_column(row) do |data|
          play << data.text
        end
      end
    end

    return game_rows, home_team, away_team, game_date, :cbs
  end
end
