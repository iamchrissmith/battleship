require './lib/square'
require './lib/ship'

class Board
  attr_reader :size, :root
  def initialize(size)
    @size = size
    @root = nil
    @ships = {player: [], comp: []}
    # build_board
  end

  def build_board
    grid = Array.new(@size) { Array.new(@size) { '' } }
    @size.times do |row|
      @size.times do |column|
        if @root.nil?
          @root = Square.new(row,column)
          square = @root
        else
          square = Square.new(row,column)

          if column > 0
            left = grid[row][column-1]
            square.neighbors[:left] = left
            left.neighbors[:right] = square
          end
          if row > 0
            above = grid[row-1][column]
            square.neighbors[:above] = above
            above.neighbors[:below] = square
          end
        end
        grid[row][column] = square
      end
    end
  end



  # I should move this to inside the square itself
  # Maybe still have a jump_to_square function here
  def jump_to_square(row, column, square = @root)
    return nil if row >= @size || column >= @size
    
    until square.row == row
      square = square.neighbors[:below] if square.row < row
      square = square.neighbors[:above] if square.row > row
    end
    until square.column == column
      square = square.neighbors[:right] if square.column < column
      square = square.neighbors[:left] if square.column > column
    end
    square
  end

  def all_sunk?
    player = @ships[:player].all? { |ship| ship.sunk?}
    comp = @ships[:comp].all? { |ship| ship.sunk? }
    player || comp
  end
end
