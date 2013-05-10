
require './app/scrape/game_info'
require './app/services/nba/base_statistics'
require './app/scrape/playbyplay/play'
require './app/scrape/playbyplay/convert_play'

module Scrape
  class TransformPlaybyplayData

    def self.run(*args)
      File.open("play_by_play_not_available.txt", "w") {|f| f.write("#{args[1..-1]} ")} and return if args.first.empty?
      plays = convert_plays(*args)
      play_hashes = plays.reject {|play| play.is_ignorable?}.map {|play| Scrape::ConvertPlay.to_hash(play)}
      saved_plays = save_plays(play_hashes)
      verify_saved_plays(saved_plays)
    end

    def self.verify_free_throws(plays)
      grouped_plays = plays.group_by {|play| play.seconds_passed}
      missing_plays = grouped_plays.map {|time, grouped_plays| find_missing_free_throw(grouped_plays)}.compact
      plays + missing_plays
    end

    def self.find_missing_free_throw(grouped_plays)
      first_free_throw = find_play_with_keyword(grouped_plays, "1 of 2")
      second_free_throw = find_play_with_keyword(grouped_plays, "2 of 2")
      if first_free_throw.present? and second_free_throw.blank?
        return first_free_throw.duplicate_with_new_description(first_free_throw.description.sub("1", "2"))
      end
    end

    def self.find_play_with_keyword(plays, keyword)
      plays.find {|play| play.description.include? keyword }
    end

    def self.verify_saved_plays(saved_plays)
      team     = saved_plays.first.team
      opponent = saved_plays.first.opponent
      game_date = saved_plays.first.game_date

      verify_team_tallies(team, game_date)
      verify_team_tallies(opponent, game_date)
    end

    def self.verify_team_tallies(team, game_date)
      LineTypeFactory
      team_total = GameLine.where(line_name: team, is_total: true, game_date: game_date.to_date).first
      return unless team_total
      Nba::TalleableStatistics.each do |statistic|
        method_name = "is_#{statistic.to_s.singularize}" 
        tally = PlayModel.where(team: team, game_date: game_date, "#{method_name}" => true).count
        File.open("playbyplay_errors.txt", "a"){|f| f << "results don't match for #{method_name}. #{team} on #{game_date} #{tally} #{team_total.send(statistic)}"} unless tally == team_total.send(statistic)
      end
    end

    def self.save_plays(play_hashes)
      play_hashes.map do |play_hash|
        PlayModel.create!(play_hash)
      end
    end

    TIME = 0
    AWAY_DESCRIPTION = 1
    SCORE = 2
    HOME_DESCRIPTION = 3

    def self.convert_plays(*args)
      plays = args.shift
      game_info = Scrape::GameInfo.new(*args)
      quarter = 1


      converted_plays = []
      plays.each do |play|
        if play.size == 4
          converted_plays << Scrape::Play.new(play[TIME], play[AWAY_DESCRIPTION], play[SCORE], play[HOME_DESCRIPTION], quarter, game_info)
        elsif play.size == 2
          quarter += 1 if play[1].include? "Quarter"
        end
      end

      #select all splittable plays
      splittable_plays = converted_plays.select {|play| play.is_splittable?}
      #create split plays
      split_plays = splittable_plays.map { |play| play.split_description }.flatten
      #remove original from plays list
      converted_plays -= splittable_plays
      #add split plays to plays list
      converted_plays += split_plays
    end
  end
end
