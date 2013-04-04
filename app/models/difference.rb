module Difference
  def redefine_formulas
    Nba::StatFormulas.top_level_methods.each do |formula|
      formula_method = method(formula)

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
