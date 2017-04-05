require './lib/validate_module'
class Player
  include Validate
  attr_reader :name
  attr_accessor :board

  def initialize(name)
    @name = name
    @board = nil
  end

  def before_ship_placement_message; end

  def after_ship_placement_message; end

  def get_locations(length)
    raise NotImplementedError
  end

  def shoot(target)
    where = get_target
    square = target.board.translate_location(where)
    success = square.hit?
    [where, success]
  end

  def generate_ships(number)
    length = 2
    number.times do
      locations = get_locations(length)
      send_ship(locations)
      length += 1
    end
  end

  def send_ship(locations)
    board.place_ship(locations)
  end

  def build_board
    @board.build_board
  end

  def all_sunk?
    @board.all_sunk?
  end

  def translate_location(readable)
    @board.translate_location(readable)
  end
end
