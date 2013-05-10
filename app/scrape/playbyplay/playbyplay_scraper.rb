require './lib/mechanize/page'

class PlaybyplayScraper
  include ScraperTools

  PLAYBYPLAY_SECTIONS = "table.mod-data tr"
  AWAY_TEAM_FROM_TITLE = ".team.away .team-info a"
  HOME_TEAM_FROM_TITLE = ".team.home .team-info a"
  GAME_TIME = ".game-time-location p"

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

    agent.get(url) do |page|

      away_team = page.text_of(AWAY_TEAM_FROM_TITLE) || "Hornets"
      home_team = page.text_of(HOME_TEAM_FROM_TITLE) || "Hornets"
      game_date = DateTime.parse(page.text_of(GAME_TIME))

      table = page.search(PLAYBYPLAY_SECTIONS)

      each_row(table) do |row|
        play = []
        game_rows << play

        each_column(row) do |data|
          play << data.text
        end
      end
    end

    return game_rows, home_team, away_team, game_date
  end
end
