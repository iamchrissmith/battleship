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

  def location_not_occupied?(readable)
    square = board.translate_location(readable)
    square.ship.nil?
  end

  private

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
