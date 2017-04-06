require 'pry'
require './lib/player'
require './lib/display'
require './lib/messages_human_module'

class Human < Player
  include Display
  include HumanMessages

  def get_locations(length)
    valid_coordinates = false
    until valid_coordinates
      ship_placement_message(length)
      coordinates_text = get_user_input
      coordinates = coordinates_text.split(" ")
      each_valid = validate_each_coordinate(coordinates)
      valid_together = validate_group(coordinates, length)
      valid_coordinates = each_valid && valid_together
    end
    coordinates.map { |coordinate| coordinate}
  end

  def get_target(target)
    start_shot_message
    valid_shot = false
    until valid_shot
      target_text = get_user_input
      valid_shot = validate_shot(target, target_text)
    end
    target_text
  end

  def validate_shot(target, text)
    row, column = split_location(text)
    valid_location = validate_row(row.upcase) && validate_column(column)
    return false unless valid_location
    not_fired_at = target.location_not_targeted?(text)
    error_already_shot_there_message if !not_fired_at
    not_fired_at
  end
end
