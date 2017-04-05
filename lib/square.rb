require 'pry'

class Square
  attr_reader   :row,
                :column,
                :neighbors,
                :status
  attr_accessor :ship

  def initialize(row, column)
    @row = row
    @column = column

    @neighbors = {
      above: nil,
      below: nil,
      left: nil,
      right: nil
    }

    @ship = nil
    @status = nil
  end

  def hit?
    if !@ship
      @status = :miss
      false
    else
      @status = :hit
      @ship.life -= 1
      true
    end
  end

  def go_in(here, there, *directions)
    return directions[1] if here < there
    return directions[0] if here > there
  end

  def find_square(row, column, square = self)
    while !square.nil? && square.row != row
      square = go_in(square.row,
                      row,
                      square.neighbors[:above],
                      square.neighbors[:below])
    end
    while !square.nil? && square.column != column
      square = go_in(square.column,
                      column,
                      square.neighbors[:left],
                      square.neighbors[:right])
    end
    return nil if square.nil?
    square
  end
end
