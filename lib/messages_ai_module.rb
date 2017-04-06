module AIMessages
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
end
