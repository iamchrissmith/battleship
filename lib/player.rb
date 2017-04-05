require './lib/validate_module'
class Player
  include Validate
  attr_reader :name
  attr_accessor :board

  def initialize(name)
    @name = name
    @board = nil
  end

  def before_ship_placement_message
    nil
  end

  def after_ship_placement_message
    nil
  end

  def get_locations(length)
    raise NotImplementedError
  end

  def shoot(target)
    where = target.get_target
    square = target.board.translate_location(where)
    success = square.hit?
    [where, success]
  end
  ###### Move to subclasses
  def get_target
    not_fired_at = false
    until not_fired_at
      row = get_random_row
      column = get_random_column
      not_fired_at = location_not_targeted?("#{row}#{column}")
    end
    "#{row}#{column}"
  end
  def our_rows
    board.letter_rows
  end
  def get_random_row
    random = rand(board.size)
    rows = our_rows
    rows[random]
  end

  def get_random_column
    (rand(board.size) + 1).to_s
  end

  ##########

  def generate_ships(number)
    length = 2
    number.times do |n|
      locations = get_locations(length)
      send_ship(locations)
      length += 1
    end
  end

  def send_ship(locations)
    board.place_ship(locations)
  end
end
