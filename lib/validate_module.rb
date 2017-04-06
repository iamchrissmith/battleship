module Validate
  def valid_directions(length, start)
    directions = []
    directions << "above" if can_go_up?(start, length)
    directions << "below" if can_go_down?(start, length)
    directions << "left" if can_go_left?(start, length)
    directions << "right" if can_go_right?(start, length)
    get_locations(length) if directions.length == 0
    directions
  end

  def no_overlap?(potential_locations)
    potential_locations.none? do |location|
      row, column = split_location(location)
      location_occupied?("#{row}#{column}")
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

  def validate_location(text)
    # return !!error_only_two_char unless text.length == 2
    text = text.upcase
    row, column = split_location(text)
    # break these into series of helper methods
    valid_row = validate_row(row)
    return false unless valid_row
    valid_column = validate_column(column)
    return false unless valid_column

    if location_occupied?(text)
      error_ships_cannot_overlap
      return false
    end
    true
  end

  def validate_row(row)
    unless our_rows.include?(row)
      error_characters_must_be_on_board
      return false
    end
    true
  end

  def validate_column(column)
    unless ("1"..board.size.to_s).include?(column)
      error_characters_must_be_on_board
      return false
    end
    true
  end

  def can_go_up?(start, length)
    rows = our_rows
    row, column = split_location(start)
    index = rows.index(row) + 1
    end_index = index - length
    return false if end_index < 0
    locations = populate_locations(start, "above", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def can_go_down?(start, length)
    rows = our_rows
    row, column = split_location(start)
    index = rows.index(row)
    return false if index + length > board.size
    locations = populate_locations(start, "below", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def can_go_left?(start, length)
    row, column = split_location(start)
    return false if column.to_i - length < 0
    locations = populate_locations(start, "left", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def can_go_right?(start, length)
    row, column = split_location(start)
    return false if column.to_i + length > board.size
    locations = populate_locations(start, "right", length, [start])
    return false unless no_overlap?(locations)
    true
  end

  def long_enough?(entered, length)
    long_enough = entered - length
    return true if (long_enough == 0)
    if (long_enough < 0)
      error_too_short(length)
      return false
    elsif (long_enough > 0)
      error_too_long(length)
      return false
    end
  end

  def sequential?(coordinates)
    if coordinates_sequential?(coordinates)
      return true
    end
    error_must_be_sequential
    false
  end

  def coordinates_sequential?(coordinates)
    coordinates.each_cons(2).all? do |this_loc,next_loc|
      this_row, this_column = split_location(this_loc)
      next_row, next_column = split_location(next_loc)
      column_seq = next_column.to_i == this_column.to_i + 1
      row_seq = letter_to_number(next_row) == letter_to_number(this_row) + 1
      column_seq || row_seq
    end
  end
end
