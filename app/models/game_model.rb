module GameModel
  module ClassMethods
    def define_line


    end

  end

  def self.included(base)
    base.extend(ClassMethods)
    base.define_line
  end

end
