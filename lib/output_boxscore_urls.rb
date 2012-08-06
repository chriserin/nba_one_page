require 'mechanize'
require 'boxscore_interpreter'

fields = [:name, :minutes, :field_goal_info, :threes_info, :free_throws_info, :offensive_rebounds, :defensive_rebouds, :total_rebounds, :assists, :blocks, :turnovers, :personal_fouls, :plus_minus, :points]

agent = Mechanize.new
s_date = Date.parse("2011-12-25")
#s_date = Date.parse("2012-02-26")
e_date = Date.parse("2012-04-26")
#e_date = Date.parse("2012-01-01")

(s_date..e_date).each do |date|
  sleep 1
  agent.get("http://espn.go.com/nba/scoreboard?date=#{date.strftime('%Y%m%d')}/") do |page|
    puts page.canonical_uri
    page.links_with(:href => %r{boxscore}).group_by {|l| l.href }.values.map{|v| v.first }.each do |boxscore|
      boxscore_data = []
      sleep 1
      agent.get boxscore.href do |page|
        home_team = page.at("table.mod-data thead:nth-child(7) tr:nth-child(1)").text
        away_team = page.at("table.mod-data thead:nth-child(1) tr:nth-child(1)").text
        home_score = page.at(".team.home span").text
        away_score = page.at(".team.away span").text

        page.search("table.mod-data > tbody").each do |table_body|

          body_data = []
          table_body.css("tr").each do |table_row|

            line_data = []
            table_row.css("td").each do |table_data|
              line_data << table_data.text
            end
            body_data << line_data

          end

          boxscore_data << body_data
        end

        BoxscoreInterpreter.interpret_data(boxscore_data, home_team, away_team, date, home_score, away_score)
      end
    end
  end
end
