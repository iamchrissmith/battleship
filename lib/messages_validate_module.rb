module ValidateMessages
  def error_only_two_char
    puts "Location can only be 2 chars long."
  end

  def error_too_short(length)
    puts "Too Short. This is a #{length.humanize}-unit ship"
  end

  def error_too_long(length)
    puts "Too Long. This is a #{length.humanize}-unit ship"
  end

  def error_must_be_sequential
    puts "Location must be sequential in order (i.e. A1 A2 not A2 A1)."
  end

  def error_characters_must_be_on_board
    puts "All characters must be on the board"
  end

  def error_ships_cannot_overlap
    puts "Ships cannot overlap."
  end

end
