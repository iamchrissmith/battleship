class Ship
  # attr_reader :length, :squares
  # attr_accessor :hits, :life
  attr_accessor :life
  def initialize (life)
    @life = life
    # @squares = squares
    # @length = length
    # @hits = 0
  end

  def sunk?
    @life == 0
  end
end
