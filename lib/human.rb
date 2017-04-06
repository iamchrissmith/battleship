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
      # Validate other parts of the shot
      not_fired_at = target.location_not_targeted?(target_text)
      error_already_shot_there_message if !not_fired_at
      valid_shot = not_fired_at # plus other validations
    end
    target_text
  end
end
