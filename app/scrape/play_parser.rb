class Scrape::PlayParser
  KEY_WORDS = %w{
    misses
    makes
    Jumpball
    gains\ possession
    offensive\ rebound
    defensive\ rebound
    jumper
    two\ point\ shot
    three\ point\ jumper
    running\ jumper
    tip\ shot
    hook\ shot
    layup
    driving\ layup
    driving\ dunk
    dunk
    slam\ dunk
    turnover
    bad\ pass
    out\ of\ bounds\ lost\ ball
    lost\ ball
    double\ dribble
    traveling
    discontinue\ dribble
    steals
    assists
    offensive\ charge
    personal\ block
    loose\ ball\ foul
    personal\ foul
    shooting\ foul
    draws\ the\ foul
    technical\ foul
    free\ throw
    blocks
    enters\ the\ game\ for
    offensive\ team\ rebound
    defensive\ team\ rebound
    offensive\ goaltending
    shot\ clock\ turnover
  }
  def initialize(play_description)
  end

  def key_words(description)
    KEY_WORDS.each do |keywords|

    end
  end
end
