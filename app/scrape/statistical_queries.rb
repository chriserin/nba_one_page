module Scrape
  module StatisticalQueries
    SHOT_TYPES = %w{
      two\ point\ shot
      three\ point\ jumper
      running\ jumper
      tip\ shot
      hook\ shot
      driving\ layup
      layup
      driving\ dunk
      slam\ dunk
      dunk
      jumper
    }

    TURNOVER_TYPES = %w{
      turnover
      bad\ pass
      out\ of\ bounds\ lost\ ball
      lost\ ball
      double\ dribble
      traveling
      discontinue\ dribble
    }

    FOUL_TYPES = %w{
      offensive\ charge
      personal\ block
      loose\ ball\ foul
      personal\ foul
      shooting\ foul
      technical\ foul
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
    THREE_POINTER = "three pointer"
    FREE_THROW = "free throw"
    OFFENSIVE_REBOUND = "offensive rebound"
    DEFENSIVE_REBOUND = "defensive rebound"
    ASSIST = "assists"
    STEAL = "steals"
    BLOCK = "blocks"
    ENTERS_THE_GAME_FOR = "enters the game for"
    EXITS_THE_GAME = "exits the game"
    DRAWS_THE_FOUL = "draws the foul"

    ALL_KEYWORDS = [MAKES, MISSES, THREE_POINT_JUMPER, THREE_POINTER, FREE_THROW, OFFENSIVE_REBOUND, DEFENSIVE_REBOUND, ASSIST, STEAL, BLOCK, ENTERS_THE_GAME_FOR, EXITS_THE_GAME ] + FOUL_TYPES + SHOT_TYPES + TURNOVER_TYPES

    def is_field_goal_attempted?
      shot_type = SHOT_TYPES.find do |shot_type|
        description.include? shot_type
      end

      return shot_type.present?
    end

    def is_field_goal_made?
      return false unless is_field_goal_attempted?
      description.include? MAKES
    end

    def is_three_made?
      description.include? MAKES and is_three_attempted?
    end

    def is_three_attempted?
      description.include? THREE_POINT_JUMPER or description.include? THREE_POINTER
    end

    def is_free_throw_attempted?
      description.include? FREE_THROW
    end

    def is_free_throw_made?
      description.include? MAKES and description.include? FREE_THROW
    end

    def is_offensive_rebound?
      description.include? OFFENSIVE_REBOUND
    end

    def is_defensive_rebound?
      description.include? DEFENSIVE_REBOUND
    end

    def is_rebound?
      is_offensive_rebound? or is_defensive_rebound?
    end

    def is_assist?
      description.include? ASSIST
    end

    def is_steal?
      description.include? STEAL
    end

    def is_block?
      description.include? BLOCK
    end

    def is_turnover?
      turnover_type = TURNOVER_TYPES.find do |turnover_type|
        description.include? turnover_type
      end

      turnover_type.present?
    end

    def is_foul?
      foul_type = FOUL_TYPES.find do |foul_type|
        description.include? foul_type
      end
    end

    def is_splittable?
      split_type.present?
    end

    def split_type
      SPLITTABLE_TYPES.find do |split_type|
        description.include? split_type
      end
    end
  end
end
