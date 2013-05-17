module Scrape
  module CbsStatisticalQueries
    SHOT_TYPES = %w{
      jump\ shot
      floating\ jump\ shot
      running\ jump\ shot
      turnaround\ jump\ shot
      leaning\ jump\ shot
      driving\ layup
      reverse\ layup
      finger-roll\ layup
      layup
      slam\ dunk
      dunk\ shot
      mini\ hook\ shot
      hook\ shot
    }

    TURNOVER_TYPES = %w{
      lost\ ball\ turnover\ on
      offensive\ foul\ turnover\ on
      bad\ pass\ turnover\ on
      travelling\ turnover\ on
      illegal\ pick\ turnover\ on
      out\ of\ bounds\ turnover\ on
      3-second\ violation\ turnover\ on
      double\ dribble\ turnover\ on
    }

    FOUL_TYPES = %w{
      shooting\ foul\ on
      personal\ foul\ on
      offensive\ foul\ on
      away\ from\ play\ foul\ on
      loose\ ball\ foul\ on
    }

    MAKES = "made"
    MISSED = "missed"
    FREE_THROW = "free throws"
    AND_ONE_FREE_THROW = "free throw"
    TECHNICAL_FREE_THROW = "technical free throw"
    THREE_POINT_JUMPER = "3-pt. jump shot"
    THREE_POINT_RUNNING_JUMPER = "3-pt. running jump shot"
    OFFENSIVE_REBOUND = "offensive rebound by"
    DEFENSIVE_REBOUND = "defensive rebound by"
    ASSIST = "assist"
    STEAL = "stolen by"
    BLOCK = "blocked by"
    JUMPBALL = "jumpball received by"
    TECHNICAL_FOUL = "technical foul on"
    FLAGRANT_ONE = "flagrant type 1 foul on"
    FLAGRANT_TWO = "flagrant type 2 foul on"
    SHOTCLOCK_VIOLATION = "24-second shotclock violaton turnover on"

    SPLITTABLE_TYPES = [ASSIST, STEAL, BLOCK]

    ALL_KEYWORDS = SHOT_TYPES + FOUL_TYPES + TURNOVER_TYPES +
      [MAKES, MISSED, FREE_THROW, TECHNICAL_FREE_THROW, THREE_POINT_JUMPER, THREE_POINT_RUNNING_JUMPER] + 
      [OFFENSIVE_REBOUND, DEFENSIVE_REBOUND, ASSIST, STEAL, BLOCK, JUMPBALL, TECHNICAL_FOUL] +
      [FLAGRANT_ONE, FLAGRANT_TWO, SHOTCLOCK_VIOLATION]

    def is_attempted_field_goal?
      shot_type = SHOT_TYPES.find do |shot_type|
        matchable_description =~ /#{shot_type}/i
      end

      return shot_type.present?
    end

    def is_made_field_goal?
      is_attempted_field_goal? and matchable_description.include? MAKES
    end

    def is_made_three?
      matchable_description.include? MAKES and is_attempted_three?
    end

    def is_attempted_three?
      matchable_description.include? THREE_POINT_JUMPER or matchable_description.include? THREE_POINT_RUNNING_JUMPER
    end

    def is_attempted_free_throw?
      matchable_description.include? FREE_THROW or matchable_description.include? TECHNICAL_FREE_THROW or matchable_description.include? AND_ONE_FREE_THROW
    end

    def is_made_free_throw?
      matchable_description.include? MAKES and is_attempted_free_throw?
    end

    def is_offensive_rebound?
      matchable_description.include? OFFENSIVE_REBOUND
    end

    def is_defensive_rebound?
      matchable_description.include? DEFENSIVE_REBOUND
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
      turnover_type = TURNOVER_TYPES.find do |turnover_type|
        matchable_description.include? turnover_type
      end

      turnover_type.present?
    end

    def is_ignorable?
      matchable_description == "full timeout" or matchable_description == "20-second timeout" or matchable_description =~ /jumpball/ or description == ""
    end

    def is_personal_foul?
      foul_type = FOUL_TYPES.find do |foul_type|
        matchable_description.include? foul_type
      end

      foul_type.present?
    end

    def is_splittable?
      split_type.present?
    end

    def split_type
      SPLITTABLE_TYPES.find do |split_type|
        matchable_description.include? split_type
      end
    end
  end
end
