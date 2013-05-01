class Scrape::TransformPlaybyplayData

  def self.run(*args)
    plays = convert_plays(*args)
  end

  TIME = 0
  AWAY_DESCRIPTION = 1
  SCORE = 2
  HOME_DESCRIPTION = 3

  def self.convert_plays(*args)
    plays = args.first
    converted_plays = []
    plays.each do |play|
      converted_plays << Scrape::Play.new(play[TIME], play[AWAY_DESCRIPTION], play[SCORE], play[HOME_DESCRIPTION])
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
