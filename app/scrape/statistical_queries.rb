module Scrape
  module StatisticalQueries
    SHOT_TYPES = %w{
      three\ point\ running\ jumper
      three\ point\ jumper
      three\ pointer
      running\ jumper
      jumper
      two\ point\ shot
      tip\ shot
      hook\ shot
      shot
      driving\ layup
      layup
      driving\ dunk
      slam\ dunk
      dunk
    }

    TURNOVER_TYPES = %w{
      3\ second\ turnover
      shot\ clock\ turnover
      turnover
      bad\ pass
      out\ of\ bounds\ lost\ ball
      lost\ ball
      double\ dribble
      traveling
      travelling
      discontinue\ dribble
    }

    FOUL_TYPES = %w{
      offensive\ foul
      offensive\ charge
      personal\ block
      loose\ ball\ foul
      personal\ foul
      shooting\ foul
      personal\ take
    }

    SPLITTABLE_TYPES = %w{
      draws\ the\ foul
      blocks
      assists
      steals
    }

    MAKES = "makes"
    MISSES = "misses"
    THREE_POINT_JUMPER = "three point jumper"
    THREE_POINT_RUNNING_JUMPER = "three point running jumper"
    THREE_POINTER = "three pointer"
    FREE_THROW = "free throw"
    TECHNICAL_FREE_THROW = "technical free throw"
    OFFENSIVE_REBOUND = "offensive rebound"
    DEFENSIVE_REBOUND = "defensive rebound"
    OFFENSIVE_TEAM_REBOUND = "offensive team rebound"
    DEFENSIVE_TEAM_REBOUND = "defensive team rebound"
    ASSIST = "assists"
    STEAL = "steals"
    BLOCK = "blocks"
    ENTERS_THE_GAME_FOR = "enters the game for"
    EXITS_THE_GAME = "exits the game"
    DRAWS_THE_FOUL = "draws the foul"
    OFFENSIVE_GOALTENDING = "offensive goaltending"
    DEFENSIVE_GOALTENDING = "defensive goaltending"
    TECHNICAL_FOUL = "technical foul"
    VIOLATION = "violation"
    KICKED_BALL_VIOLATION = "kicked ball violation"
    DEFENSIVE_3_SECONDS = "defensive 3-seconds (Technical Foul)"

    ALL_KEYWORDS = [MAKES, MISSES, THREE_POINT_JUMPER, THREE_POINTER, FREE_THROW, TECHNICAL_FREE_THROW, OFFENSIVE_REBOUND, DEFENSIVE_REBOUND, ASSIST, STEAL, BLOCK, ENTERS_THE_GAME_FOR, EXITS_THE_GAME, OFFENSIVE_TEAM_REBOUND, DEFENSIVE_TEAM_REBOUND, OFFENSIVE_GOALTENDING, DEFENSIVE_GOALTENDING, DRAWS_THE_FOUL, TECHNICAL_FOUL, VIOLATION, KICKED_BALL_VIOLATION, DEFENSIVE_3_SECONDS] + FOUL_TYPES + SHOT_TYPES + TURNOVER_TYPES

    def matchable_description
      description.downcase
    end

    def is_attempted_field_goal?
      shot_type = SHOT_TYPES.find do |shot_type|
        matchable_description.include? shot_type
      end

      return (shot_type.present? || (keyword_count == 1 and matchable_description.include? MISSES)) && !matchable_description.include?("shot clock")
    end

    def is_made_field_goal?
      is_attempted_field_goal? and matchable_description.include? MAKES
    end

    def is_made_three?
      matchable_description.include? MAKES and is_attempted_three?
    end

    def is_attempted_three?
      matchable_description.include? THREE_POINT_JUMPER or matchable_description.include? THREE_POINTER or matchable_description.include? THREE_POINT_RUNNING_JUMPER
    end

    def is_attempted_free_throw?
      matchable_description.include? FREE_THROW or matchable_description.include? TECHNICAL_FREE_THROW
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

      turnover_type.present? and !is_ignorable?
    end

    def is_ignorable?
      ["bad pass", "off foul turnover"].include?(matchable_description) or keyword_count == 0
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
