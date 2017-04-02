class Ship

  def initialize(locations, owner, board)
    @squares = set_location(locations)
    @length = @squares.length
    @hits = 0
    @owner = owner
    @board = board
  end

  def set_location(locations)
    # split locations to array
    # call each square in location and pass this ship
    # add each square to @squares
  end

  def sunk?
    @hits == @length
  end
end
