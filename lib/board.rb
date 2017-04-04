require './lib/square'
require './lib/ship'

class Board
  attr_reader :size, :root, :ships, :sunk_ships
  def initialize(size)
    @size = size
    @root = nil
    @ships = []
    @sunk_ships = count_sunk_ships
  end

  def count_sunk_ships
    @ships.count { |ship| ship.sunk? }
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
            assign_horizontal_neighbor(row, column, square, grid)
          end
          if row > 0
            assign_vertical_neighbor(row, column, square, grid)
          end
        end
        grid[row][column] = square
      end
    end
  end

  def assign_horizontal_neighbor(row, column, square, grid)
    left = grid[row][column-1]
    square.neighbors[:left] = left
    left.neighbors[:right] = square
  end

  def assign_vertical_neighbor(row, column, square, grid)
    above = grid[row-1][column]
    square.neighbors[:above] = above
    above.neighbors[:below] = square
  end

  def place_ship(locations)
    squares = locations.map do |location|
      translate_location(location)
    end
    ship = Ship.new(squares.length)
    @ships << ship
    squares.each do |square|
      square.ship = ship
    end
    ship
  end

  def jump_to_square(row, column, square = @root)
    square.find_square(row, column, square)
  end

  def all_sunk?
    @ships.all? { |ship| ship.sunk?}
  end

  def letter_rows
    rows = ("A".."Z").to_a
    rows.slice(0...@size)
  end

  def letter_to_number(letter)
    alphabet = letter_rows
    alphabet.index(letter.upcase)
  end

  def translate_location(readable)
    row = letter_to_number(readable[0])
    column = readable[1].to_i - 1
    jump_to_square(row, column)
  end

  # private
end
