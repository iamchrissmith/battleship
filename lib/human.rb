require 'pry'
require './lib/player'
require './lib/display'

class Human < Player
  include Display

  def before_ship_placement_message
    puts "You now need to layout your two ships."
    puts "The first is two units long and the second is three units long."
    puts "The grid has A1 at the top left and D4 at the bottom right."
    puts "==============================================================="
  end

  def get_locations(length)
    valid_coordinates = false
    until valid_coordinates
      puts "Enter the squares for the #{length.humanize}-unit ship:"
      coordinates_text = get_user_input
      coordinates = coordinates_text.split(" ")
      each_valid = validate_each_coordinate(coordinates)
      valid_together = validate_group(coordinates, length)
      valid_coordinates = each_valid && valid_together
    end
    coordinates.map { |coordinate| coordinate.split('')}
  end

  def get_target
    puts "Enter the squares you would like to shoot (i.e. A1)"
    not_fired_at = false
    until not_fired_at
      target_text = get_user_input
      return if target_text == ''
      not_fired_at = location_not_targeted?(target_text)
    end
    target_text
  end
end
