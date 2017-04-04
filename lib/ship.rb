class Ship
  attr_reader :length, :squares
  attr_accessor :hits
  def initialize(squares)
    @squares = squares
    @length = @squares.length
    @hits = 0
  end

  def sunk?
    @hits == @length
  end
end
