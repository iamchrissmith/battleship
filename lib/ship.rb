class Ship
  attr_reader :length
  # attr_accessor :hits, :life
  attr_accessor :life
  def initialize (life)
    @life = life
    # @squares = squares
    @length = life
    # @hits = 0
  end

  def sunk?
    @life == 0
  end

  def score_hit
    @life -= 1 # if @life != 0
  end
end
