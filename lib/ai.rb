require './lib/player'

class AI < Player

  def after_ship_placement_message
    puts "I have laid out my ships on the grid."
  end

  def get_locations(length)
    start = get_first_location
    ordinal_options = find_direction(length, start)
    where_to = ordinal_options[0]
    locations = [start]
    locations = populate_locations(start, where_to, length, locations)
    locations.sort { |a,b| [ a[1], a[0] ] <=> [ b[1], b[0] ] }
  end

  def populate_locations(start, direction, length, locations = [])
    next_loc = move(start,direction)
    locations << next_loc
    if locations.length < length
      locations = populate_locations(locations.last, direction, length, locations)
    end
    locations
  end

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

  def find_direction(length, start)
    directions = []
    directions << "up" if can_go_up?(start[0], length)
    directions << "down" if can_go_down?(start[0], length)
    directions << "left" if can_go_left?(start[1], length)
    directions << "right" if can_go_right?(start[1], length)
    directions.shuffle!
  end

  def get_first_location
    row = get_random_row
    column = get_random_column
    [row, column]
  end

  private

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

  def can_go_up?(row, length)
    rows = our_rows
    index = rows.index(row) + 1
    index - length >= 0
  end
  def can_go_down?(row, length)
    rows = our_rows
    index = rows.index(row)
    index + length <= board.size
  end
  def can_go_left?(column, length)
    column.to_i - length >= 0
  end
  def can_go_right?(column, length)
    column.to_i + length <= board.size
  end
end
