require './lib/square'
require './lib/ship'

class Board
  attr_reader :size, :root, :ships, :sunk_ships
  def initialize(size)
    @size = size
    @root = nil
    @ships = []
  end

  def sunk_ships
    return 0 if @ships.length == 0
    @ships.count { |ship| ship.sunk? }
  end

  def build_board
    grid = Array.new(@size) { Array.new(@size) { '' } }
    @size.times do |row|
      build_row(row, grid)
    end
  end

  def build_row(row, grid)
    @size.times do |column|
      build_square(row, column, grid)
    end
  end

  def build_square(row,column,grid)
    letter_row = get_letter(row)
    column_name = (column + 1).to_s
    square = Square.new(letter_row,column_name)
    @root = square if @root.nil?
    assign_horizontal_neighbor(row, column, square, grid) if column > 0
    assign_vertical_neighbor(row, column, square, grid) if row > 0
    grid[row][column] = square
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
      jump_to_square(location[0],location[1])
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

  def get_letter(index)
    alphabet = letter_rows
    alphabet[index]
  end

  def letter_to_number(letter)
    alphabet = letter_rows
    alphabet.index(letter.upcase)
  end

  def translate_location(readable)
    readable = readable.upcase
    row = readable[0]
    # column = readable[1..-1]
    # readable.delete(row)
    column = readable[1]
    jump_to_square(row, column)
  end
end
