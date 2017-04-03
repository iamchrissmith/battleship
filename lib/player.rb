class Player
  attr_reader :name
  attr_accessor :board

  def initialize(name)
    @name = name
    @board = nil
  end
end
