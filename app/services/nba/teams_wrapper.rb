module Nba
  class TeamsWrapper
    class << self
      def conferences
        ['eastern', 'western']
      end

      def teams_by_conference(conference)
        teams_without_new_jersey.select { |team, info| info[:conference] == conference }
      end

      def divisions_by_conference(conference)
        teams_by_conference(conference).map { |team, info| info[:div] }.uniq
      end

      def teams_by_division(division)
        teams_without_new_jersey.select { |team, info| info[:div] == division }.keys
      end

      def teams_without_new_jersey
        Nba::TEAMS.reject { |team| team =~ /Jersey/ }
      end
    end
  end
end
