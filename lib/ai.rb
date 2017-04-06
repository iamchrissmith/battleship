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

  def shot_message(success)
    puts "Oh no! The computer hit you!" if success
    puts "Phew! It missed" if !success
    sleep 1
  end

  def sunk_message(length)
    puts "Look out the computer sunk your #{length.humanize}-unit ship!"
  end

  def victory_message(moves, minutes, seconds)
    puts "Booo! You lost the game to the computer."
    puts "It only too it #{moves[name]} moves and #{minutes} #{seconds} to defeat you."
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
    locations.sort { |a,b| [ a[0], a[1] ] <=> [ b[0], b[1] ] }
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
