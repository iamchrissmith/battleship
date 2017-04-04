module Validate
  def find_direction(length, start)
    directions = []
    directions << "up" if can_go_up?(start, length)
    directions << "down" if can_go_down?(start, length)
    directions << "left" if can_go_left?(start, length)
    directions << "right" if can_go_right?(start, length)
    if directions.length == 0
      get_locations(length)
    end
    directions.shuffle!
  end

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

  def no_overlap?(potential_locations)
    potential_locations.all? do |location|
      location_not_occupied?("#{location[0]}#{location[1]}")
    end
  end

  def location_not_occupied?(readable)
    square = board.translate_location(readable)
    square.ship.nil?
  end

  ####

  def validate_each_coordinate(coordinates)
    each_valid = coordinates.all? do |coordinate|
      validate_location(coordinate)
    end
    return each_valid if !each_valid
    each_valid
  end

  def validate_group(coordinates, length)
    sequential = coordinates_sequential?(coordinates)
    if !sequential
      puts "Location must be sequential in order (i.e. A1 A2 not A2 A1)."
      return false
    end
    long_enough = coordinates.length - length
    if (long_enough < 0)
      puts "Too Short. This is a #{length.humanize}-unit ship"
      return false
    elsif (long_enough > 0)
      puts "Too Long. This is a #{length.humanize}-unit ship"
      return false
    end
    sequential && (long_enough == 0)
  end

  def coordinates_sequential?(coordinates)
    coordinates.each_cons(2).all? do |this_loc,next_loc|
      column_seq = next_loc[1].to_i == this_loc[1].to_i + 1
      row_seq = board.letter_to_number(next_loc[0]) == board.letter_to_number(this_loc[0]) + 1
      column_seq || row_seq
    end
  end

  def validate_location(text)
    unless text.length == 2
      puts "Location can only be 2 chars long."
      return false
    end
    coordinates = text.split('')
    row = coordinates[0].upcase
    valid_row = validate_row(row)
    return false unless valid_row
    column = coordinates[1]
    valid_column = validate_column(column)
    return false unless valid_column

    unless location_not_occupied?(text)
      puts "Ships cannot overlap."
      return false
    end
    true
  end

  def validate_row(row)
    unless row.is_a? String
      puts "First Char must be a Letter"
      return false
    end
    unless board.letter_to_number(row).is_a? Integer
      puts "First Char must be on the board"
      return false
    end
    true
  end

  def validate_column(column)
    unless ("1"..board.size.to_s).include?(column)
      puts "2nd Char must be on the board"
      return false
    end
    true
  end

end
