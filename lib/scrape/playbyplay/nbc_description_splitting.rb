module Scrape
  module NbcDescriptionSplitting

    def split_description_by_type(description)
      case description
      when /blocks/
        split_blocks_description(description)
      when /assist/
        split_assist_description(description)
      when /steals/
        split_steals_description(description)
      when /substitution/i
        split_substitution_description(description)
      when /jump ball/i
        split_jumpball_description(description)
      end
    end

    def split_assist_description(description)
      split_index = [end_position(description, /(feet out|foot out)/), end_position(description, shot_type)].max + 1
      return description[0...split_index].strip, description[split_index..-1].strip
    end

    def split_blocks_description(description)
      split_index = end_position(description, "blocks a")
      return description[0...split_index].strip, description[split_index..-1].strip
    end

    def split_steals_description(description)
      split_result = description.split /from/
      return split_result.first.strip, split_result.last[0..-2].strip + " turnover"
    end

    def end_position(description, keyword)
      description.index(keyword) + ($1 || keyword).size rescue -1
    end

    def split_substitution_description(description)
      description.match /Substitution:\s(.*)\sin\sfor\s(.*)\./
      return  "#{$2} exits game", "#{$1} enters game"
    end

    def split_jumpball_description(description)
      split_match = description.match /Jump Ball:(.*)vs\.(.*?)(\.$|--)/
      return "Jump Ball: #{$1.strip}", "Jump Ball: #{$2.strip}"
    end

    def split_team_by_type(description, team, game_info)
      case description
      when /blocks/
        return game_info.other_team(team), team
      when /assist/
        return team, team
      when /substitution/i
        return team, team
      when /steals/
        return game_info.other_team(team), team
      when /jump\sball/i
        return team, game_info.other_team(team)
      end
    end
  end
end
