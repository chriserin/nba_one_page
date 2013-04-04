module TrueFalseComparison
  def <=>(other)
    raise ArgumentError unless [TrueClass, FalseClass].include?(other.class)
    other ? (self ? 0 : -1) : (self ? 1 : 0)
  end
end

TrueClass.send(:include, TrueFalseComparison)
FalseClass.send(:include, TrueFalseComparison)
