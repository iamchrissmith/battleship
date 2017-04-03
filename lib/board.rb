require './lib/square'
require './lib/ship'

class Board
  attr_reader :size, :root, :ships
  def initialize(size)
    @size = size
    @root = nil
    @ships = []
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

  def place_ship(locations)
    # find start of ship square
    squares = locations.map do |location|
      translate_location(location)
    end
    ship = Ship.new(squares)
    @ships << ship
    squares.each do |square|
      square.ship = ship
    end
    ship
    # create new Ship and pass start square and other locations (as array)
  end

  def jump_to_square(row, column, square = @root)
    square.find_square(row, column, square)
  end

  def all_sunk?
    @ships.all? { |ship| ship.sunk?}
  end

  private
  def letter_to_number(letter)
    alphabet = ("a".."z").to_a
    alphabet.index(letter)
  end
  def translate_location(readable)
    coordinates = readable.split('')
    row = letter_to_number(coordinates[0].downcase)
    column = coordinates[1].to_i - 1
    jump_to_square(row, column)
  end
end
