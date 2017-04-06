require './lib/player'

class AI < Player

  def before_ship_placement_message
    print "Thinking..."
    3.times do
      sleep 0.25
      print "..."
    end
    sleep 0.25
    puts "..."
    sleep 0.5
  end

  def after_ship_placement_message
    puts "I have laid out my ships on the grid."
    sleep 0.5
  end

  def get_locations(length)
    start = get_first_location
    ordinal_options = valid_directions(length, start).shuffle
    where_to = ordinal_options[0]
    locations = populate_locations(start, where_to, length, [start])
    get_locations(length) if locations.length == 0
    sort_found_locations(locations)
  end

  def sort_found_locations(locations)
    locations.sort { |a,b| [ a[1], a[0] ] <=> [ b[1], b[0] ] }
  end

  def populate_locations(start, direction, length, locations)
    next_loc = move(start,direction)
    locations << next_loc
    if locations.length < length
      locations = populate_locations(locations.last, direction, length, locations)
    end
    locations
  end
# use smart squares' navigations
  def move(current, direction)
    
    case direction
    when "up"
      rows = our_rows
      index = our_rows.index(current[0])
      [rows[index - 1], current[1]]
    when "down"
      rows = our_rows
      index = our_rows.index(current[0])
      [rows[index + 1], current[1]]
    when "left"
      [current[0], (current[1].to_i - 1).to_s]
    when "right"
      [current[0], (current[1].to_i + 1).to_s]
    end
  end

  def get_first_location
    occupied = true
    while occupied
      row = get_random_row
      column = get_random_column
      occupied = location_occupied?("#{row}#{column}")
    end
    [row, column]
  end

  def get_target
    not_fired_at = false
    until not_fired_at
      row = get_random_row
      column = get_random_column
      not_fired_at = location_not_targeted?("#{row}#{column}")
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
