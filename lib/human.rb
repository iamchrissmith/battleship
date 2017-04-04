require 'pry'
require './lib/player'
require './lib/display'

class Human < Player
  include Display

  def before_ship_placement_message
    puts "You now need to layout your two ships."
    puts "The first is two units long and the second is three units long."
    puts "The grid has A1 at the top left and D4 at the bottom right."
  end

  def get_locations(length)
    valid_coordinates = false
    clear_screen
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
end
