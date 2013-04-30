class NbaPlaybyplayScraper
  include ScraperTools

  PLAYBYPLAY_SECTIONS = "table.mod-data tr"

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

    agent.get(url) do |page|
      table = page.search(PLAYBYPLAY_SECTIONS)

      each_row(table) do |row|
        play = []
        game_rows << play

        each_column(row) do |data|
          play << data
        end
      end
    end

    return game_rows
  end
end
