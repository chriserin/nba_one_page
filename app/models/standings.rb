class Standings

  attr_accessor :team_records
  ATLANTIC_DIVISION, CENTRAL_DIVISION, SOUTHEAST_DIVISION, NORTHWEST_DIVISION, PACIFIC_DIVISION, SOUTHWEST_DIVISION, EASTERN_CONFERENCE, WESTERN_CONFERENCE, LEAGUE = %w{atlantic central southeast northwest pacific southwest eastern western}

  def initialize(all_games)
    self.team_records = []
    all_games.group_by{ |line| line.team }.each_pair do |team, games|
      self.team_records << TeamRecord.new(team, games)
    end
    self
  end

  def set_games_back(teams, organization, last_number_of_games = nil)

    sorted_teams = teams.sort_by { |record| record.win_pct(last_number_of_games) }.reverse
    first_place_record = sorted_teams.first.record_last(last_number_of_games)

    sorted_teams.each do |team|
      team.set_games_back(organization, first_place_record, last_number_of_games)
    end
  end

  def get_standings_for(organization, last_number_of_games = nil)
    set_games_back(team_records.select{|team| team.in_organization(organization)}, organization, last_number_of_games)
  end

  def get_team(team_name)
    team_records.select { |team| team.team == team_name }.first
  end

  def self.get_standings
    standings = Standings.new GameLine.game_totals
  end

  def inspect
   "#{to_s}"
  end
end
