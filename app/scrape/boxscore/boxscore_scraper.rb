require './lib/mechanize/page.rb'

class BoxscoreScraper
  include ScraperTools

  BOXSCORE_TABLE        = "table.mod-data > tbody"
  AWAY_ROW_FIRST_COLUMN = "table.mod-data thead:nth-child(1) tr:nth-child(1)"
  HOME_ROW_FIRST_COLUMN = "table.mod-data thead:nth-child(7) tr:nth-child(1)"
  AWAY_SCORE_FROM_TITLE = ".team.away span"
  HOME_SCORE_FROM_TITLE = ".team.home span"
  GAME_TIME = ".game-time-location p"

  def initialize(next_step)
    @next_step = next_step
  end

  def run(boxscore_urls)
    boxscore_urls.map do |url|
      results = scrape(url)
      @next_step.run(*results)
    end
  end

  def scrape(url)
    # each element of boxscore_sections will be an array that contains lines of data.  Each element will look like this: [[points, minuts], [points, minutes]]
    boxscore_sections = []
    home_team, away_team, home_score, away_score, game_date, periods, home_turnovers, away_turnovers = nil

    agent = Mechanize.new

    agent.get(url) do |page|

      home_team  = page.text_of(HOME_ROW_FIRST_COLUMN)
      away_team  = page.text_of(AWAY_ROW_FIRST_COLUMN)
      home_score = page.text_of(HOME_SCORE_FROM_TITLE)
      away_score = page.text_of(AWAY_SCORE_FROM_TITLE)
      game_date  = DateTime.parse(page.text_of(GAME_TIME))
      periods = page.search(".period").size
      home_turnovers = get_home_turnovers(page)
      away_turnovers = get_away_turnovers(page)

      page.search(BOXSCORE_TABLE).each do |table_body|
        lines = []

        each_row(table_body) do |table_row|
          line_data = []

          each_column(table_row) do |table_data|
            line_data << table_data.text
          end

          lines << line_data
        end

        boxscore_sections << lines
      end
    end

    return boxscore_sections, home_team, away_team, game_date, home_score, away_score, periods, home_turnovers, away_turnovers
  end

  def get_away_turnovers(page)
    text = page.text_of("table.mod-data tbody:nth-child(6) tr:nth-child(3) td")
    text.match(/(\d+)\s(\(\d+\))/)[1].to_i
  end

  def get_home_turnovers(page)
    text = page.text_of("table.mod-data tbody:nth-child(12) tr:nth-child(3) td")
    text.match(/(\d+)\s(\(\d+\))/)[1].to_i
  end
end
