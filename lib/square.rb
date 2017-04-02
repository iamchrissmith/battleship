require 'pry'

class Square
  attr_reader   :row,
                :column,
                :neighbors
  attr_accessor :ship

  def initialize(row, column)
    @row = row
    @column = column
    # @board = board

    @neighbors = {
      above: nil,
      below: nil,
      left: nil,
      right: nil
    }

    @ship = nil
    @status = nil
  end

  # def set_above(row)
  #   if row - 1 >= 0
  #     above = find_square(row - 1, @column)
  #     above.set_below(self)
  #     above
  #   end
  # end
  #
  # def set_below(square)
  #   @neighbors[:below] = square
  # end
  #
  # def set_left(column)
  #   if column - 1 >= 0
  #     left = find_square(@row, column - 1)
  #     left.set_right(self)
  #     left
  #   end
  # end
  #
  # def set_right(square)
  #   @neighbors[:right] = square
  # end

  # def set_ship(ship)
  #   @ship = ship
  # end

  def hit?
    if !@ship
      @status = :miss
      false
    else
      @status = :hit
      @ship.hits += 1
      true
    end
  end

  def find_square(row, column, square = self)
    return nil if square.nil?
    if square.row < row
      square = find_square(row, column, square.neighbors[:below])
    elsif square.row > row
      square = find_square(row, column, square.neighbors[:above])
    end
    if square.column < column
      square = find_square(row, column, square.neighbors[:right])
    elsif square.column > column
      square = find_square(row, column, square.neighbors[:left])
    end
    square
  end

end
# def set_below(row)
#   if row + 1 < @board.size
#     if find_square(row + 1, @column)
#       return find_square(row + 1, @column)
#     else
#       add(Square.new(row + 1, column))
#     end
#   end
# end
# def set_right(column)
#   if column + 1 < @board.size
#     find_square(@row, column + 1)
#   end
# end
