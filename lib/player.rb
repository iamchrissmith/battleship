require "./lib/errors"

class Player
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
