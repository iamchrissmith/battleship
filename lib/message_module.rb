module HumanMessages

  def before_ship_placement_message
    puts "You now need to layout your two ships."
    puts "The first is two units long and the second is three units long."
    puts "The grid has A1 at the top left and D4 at the bottom right."
    puts "==============================================================="
  end

  def shot_message(success)
    puts "Congrats, a hit!" if success
    puts "Better luck next time..." if !success
    puts "--------"
    puts "Press ENTER to end your turn"
    gets.chomp
  end

  def already_shot_there_message
    puts "I'm sorry, but you're already targeted that location."
    puts "Please enter another target."
  end

  def error_only_two_char
    puts "Location can only be 2 chars long."
  end

  def sunk_message(length)
    puts "Wonderful! You sunk a #{length.humanize}-unit ship!"
  end

  def victory_message(moves, minutes, seconds)
    puts "Hurray! You won the game in #{moves[name]} moves and #{minutes} #{seconds}."
  end
end
