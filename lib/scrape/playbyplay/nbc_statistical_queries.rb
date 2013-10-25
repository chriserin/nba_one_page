module Scrape
  module NbcStatisticalQueries
    SHOT_TYPES = %w{
      jump\ shot
      layup\ shot
      dunk\ shot
      tip\ shot
      finger\ roll\ shot
      jump\ hook
      hook\ shot
      bank\ shot
      fade\ away
    }

    SHOT_MODIFIERS = %w{
      driving
      floating
      alley\ oop
      putback
      turnaround
      reverse
      running
      3-point
    }

    MAKES = "makes"
    MISS = "miss"
    MISSED = "missed"
    THREE_POINTER = "3-point"
    FREE_THROW = "free throw"
    OFFENSIVE_REBOUND = "offensive rebound"
    DEFENSIVE_REBOUND = "defensive rebound"
    ASSIST = "assist"
    STEAL = "steals"
    BLOCK = "blocks"
    TURNOVER = "turnover"
    FOUL = "foul"
    TECHNICAL_FOUL = "technical foul"
    FLAGRANT_1_FOUL = "flagrant type 1 foul"
    FLAGRANT_2_FOUL = "flagrant type 2 foul"
    EJECTION = "ejected"
    ILLEGAL_DEFENSE_FOUL = "illegal defense foul"
    FOUL_DUE_TO = "due to a foul"
    EXIT = "exit"
    ENTERS = "enters"
    SUBSTITUION = "substitution"

    def is_attempted_field_goal?
      return shot_type.present?
    end

    def shot_type
      SHOT_TYPES.find do |shot_type|
        matchable_description =~ /#{shot_type}/i
      end
    end

    def is_made_field_goal?
      is_attempted_field_goal? and matchable_description.include? MAKES
    end

    def is_made_three?
      matchable_description.include? MAKES and is_attempted_three?
    end

    def is_attempted_three?
      matchable_description.include? THREE_POINTER
    end

    def is_attempted_free_throw?
      matchable_description.include? FREE_THROW
    end

    def is_made_free_throw?
      matchable_description.include? MAKES and is_attempted_free_throw?
    end

    def is_offensive_rebound?
      matchable_description.include? OFFENSIVE_REBOUND and not_team_play?
    end

    def is_defensive_rebound?
      matchable_description.include? DEFENSIVE_REBOUND and not_team_play?
    end

    def not_team_play?
      return (not matchable_description.include?(Nba::TEAMS[team][:nickname].downcase))
    end

    def is_total_rebound?
      is_offensive_rebound? or is_defensive_rebound?
    end

    def is_assist?
      matchable_description.include? ASSIST
    end

    def is_steal?
      matchable_description.include? STEAL
    end

    def is_block?
      matchable_description.include? BLOCK
    end

    def is_turnover?
      matchable_description.include?(TURNOVER) and not_team_play?
    end

    def is_ignorable?
      description.include? "Event" or description.include? "Jump Ball" or is_team_play? or is_timeout? or description.include? "Starting Lineup"
    end

    def is_team_play?
      description.include?(Nba::TEAMS[@game_info.home_team][:nickname])or 
        description.include?(Nba::TEAMS[@game_info.away_team][:nickname])
    end

    def is_quarter_start?
      description =~ /Start of the/
    end

    def is_timeout?
      description.include? "timeout"
    end

    def is_quarter_end?
      description =~ /End of the/
    end

    def is_foul?
      matchable_description.include? FOUL and not matchable_description.include? FOUL_DUE_TO
    end

    def is_personal_foul?
      matchable_description.include? FOUL and not is_technical_foul? and not is_illegal_defense_foul? and not matchable_description.include? FOUL_DUE_TO
    end

    def is_splittable?
      matchable_description.include? BLOCK or matchable_description.include? ASSIST or matchable_description.include? STEAL or matchable_description.include? SUBSTITUION
    end

    def is_illegal_defense_foul?
      matchable_description.include? ILLEGAL_DEFENSE_FOUL
    end

    def is_flagrant_foul?
      matchable_description.include? FLAGRANT_1_FOUL or matchable_description.include? FLAGRANT_2_FOUL
    end

    def is_technical_foul?
      matchable_description.include? TECHNICAL_FOUL
    end

    def is_ejection?
      matchable_description.include? EJECTION
    end

    def is_entrance?
      matchable_description.include? ENTERS
    end

    def is_exit?
      matchable_description.include? EXIT
    end
  end
end
