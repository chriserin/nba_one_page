module Difference
  def redefine_formulas
    (Nba::StatFormulas.instance_methods - [:true_shooting_attempts, :possessions, :team_possessions, :opponent_possessions]).each do |formula|
      formula_method = method(formula)
      next if formula_method.arity > 0
      singleton_class.class_eval do
        define_method formula do
          first_result = formula_method.call
          @called_count += 1
          second_result = formula_method.call
          @called_count += 1
          (first_result - second_result).round 3
        end
      end
    end
  end
end
