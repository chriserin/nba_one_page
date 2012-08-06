class BlankObject
  def method_missing(m, *args, &block)
    "x"
  end
end
