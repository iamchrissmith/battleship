module Validate
  #stop navigating as though array... use Smart Squares :left,:right,etc
  def valid_directions(length, start)
    directions = []
    directions << "up" if can_go_up?(start, length)
    directions << "down" if can_go_down?(start, length)
    directions << "left" if can_go_left?(start, length)
    directions << "right" if can_go_right?(start, length)
    get_locations(length) if directions.length == 0
    directions
  end

  def no_overlap?(potential_locations)
    potential_locations.none? do |location|
      location_occupied?("#{location[0]}#{location[1]}")
    end
  end

  def location_not_targeted?(readable)
    square = translate_location(readable)
    square.status.nil?
  end

  def location_occupied?(readable)
    square = translate_location(readable)
    !square.ship.nil?
  end

  def validate_each_coordinate(coordinates)
    coordinates.all? do |coordinate|
      validate_location(coordinate)
    end
  end

  def validate_group(coordinates, length)
    entered_length = coordinates.length
    sequential?(coordinates) && long_enough?(entered_length, length)
  end

  def error_only_two_char
    puts "Location can only be 2 chars long."
  end

  def validate_location(text)
    return !!error_only_two_char unless text.length == 2
    text = text.upcase
    # break these into series of helper methods
    row = text[0].upcase
    valid_row = validate_row(row)
    return false unless valid_row

    column = text[1]
    valid_column = validate_column(column)
    return false unless valid_column

    if location_occupied?(text)
      puts "Ships cannot overlap."
      return false
    end
    true
  end

  # Could be private

  def validate_row(row)
    unless row.is_a? String
      puts "First character must be a Letter"
      return false
    end
    unless our_rows.include?(row)
      puts "First character must be on the board"
      return false
    end
    true
  end

  def validate_column(column)
    unless ("1"..board.size.to_s).include?(column)
      puts "Second character must be on the board"
      return false
    end
    true
  end
# Should I be adding 1 to can_go_up
  def can_go_up?(start, length)
    rows = our_rows
    index = rows.index(start[0]) + 1
    return false if index - length < 0
    locations = populate_locations(start, "up", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def can_go_down?(start, length)
    rows = our_rows
    index = rows.index(start[0])
    return false if index + length > board.size
    locations = populate_locations(start, "down", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def can_go_left?(start, length)
    return false if start[1].to_i - length < 0
    locations = populate_locations(start, "left", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def can_go_right?(start, length)
    return false if start[1].to_i + length > board.size
    locations = populate_locations(start, "right", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def long_enough?(entered, length)
    long_enough = entered - length
    return true if (long_enough == 0)
    if (long_enough < 0)
      puts "Too Short. This is a #{length.humanize}-unit ship"
      return false
    elsif (long_enough > 0)
      puts "Too Long. This is a #{length.humanize}-unit ship"
      return false
    end
  end

  def sequential?(coordinates)
    if coordinates_sequential?(coordinates)
      return true
    end
    puts "Location must be sequential in order (i.e. A1 A2 not A2 A1)."
    false
  end

  def coordinates_sequential?(coordinates)
    coordinates.each_cons(2).all? do |this_loc,next_loc|
      column_seq = next_loc[1].to_i == this_loc[1].to_i + 1
      row_seq = letter_to_number(next_loc[0]) == letter_to_number(this_loc[0]) + 1
      column_seq || row_seq
    end
  end
end
