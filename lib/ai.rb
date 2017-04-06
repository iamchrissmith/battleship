require './lib/player'
require './lib/messages_ai_module'

class AI < Player
  include AIMessages

  def get_locations(length)
    start = get_first_location
    ordinal_options = valid_directions(length, start).shuffle
    where_to = ordinal_options[0]
    locations = populate_locations(start, where_to, length, [start])
    get_locations(length) if locations.length == 0
    sort_found_locations(locations)
  end

  def sort_found_locations(locations)
    locations.sort do |a,b|
      a_row, a_column = split_location(a)
      a_column = a_column.to_i
      b_row, b_column = split_location(b)
      b_column = b_column.to_i
      [ a_row , a_column ] <=> [ b_row, b_column ]
    end
  end

  def populate_locations(start, direction, length, locations)
    next_loc = move(start,direction)
    locations << next_loc
    if locations.length < length
      locations = populate_locations(locations.last, direction, length, locations)
    end
    locations
  end

  def move(current, direction)
    current_square = translate_location(current)
    next_square = current_square.neighbors[direction.to_sym]
    "#{next_square.row}#{next_square.column}"
  end

  def get_first_location
    occupied = true
    while occupied
      row = get_random_row
      column = get_random_column
      occupied = location_occupied?("#{row}#{column}")
    end
    "#{row}#{column}"
  end

  def get_target(target)
    not_fired_at = false
    until not_fired_at
      row = get_random_row
      column = get_random_column
      not_fired_at = target.location_not_targeted?("#{row}#{column}")
    end
    "#{row}#{column}"
  end

  def get_random_row
    random = rand(board.size)
    rows = our_rows
    rows[random]
  end

  def get_random_column
    (rand(board.size) + 1).to_s
  end
end
